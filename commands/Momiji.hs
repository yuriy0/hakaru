{-# LANGUAGE OverloadedStrings, DataKinds, GADTs #-}

module Main where

import qualified Language.Hakaru.Pretty.Maple as Maple
import           Language.Hakaru.Syntax.AST.Transforms
import           Language.Hakaru.Syntax.TypeCheck
import           Language.Hakaru.Command

import           Data.Text
import qualified Data.Text.IO as IO
import           System.IO (stderr)

import           System.Environment

main :: IO ()
main = do
  args <- getArgs
  case args of
      [prog] -> IO.readFile prog >>= runPretty
      []     -> IO.getContents   >>= runPretty
      _      -> IO.hPutStrLn stderr "Usage: momiji <file>"

runPretty :: Text -> IO ()
runPretty prog =
    case parseAndInfer prog of
    Left  err              -> IO.hPutStrLn stderr err
    Right (TypedAST typ ast) -> do
      putStrLn $ Maple.pretty (expandTransformations ast)
      putStrLn $ ","
      putStrLn $ Maple.mapleType typ ""


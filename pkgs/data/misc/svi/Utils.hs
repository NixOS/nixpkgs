{-# LANGUAGE OverloadedStrings #-}
module Utils where

import System.Process
import System.Exit
import qualified Data.Text as T
import qualified Data.Map as M

data SourceFile = SourceFile {
  name :: T.Text
, url :: T.Text
, extraAttrs :: M.Map T.Text T.Text
}

showNixSource :: SourceFile -> IO [T.Text]
showNixSource SourceFile{name=n, url=u, extraAttrs=a} = do
  (exitcode, stdout, stderr) <- readProcessWithExitCode ("nix-prefetch-url") ["--unpack", "--name", T.unpack n, T.unpack u] ""
  return $
    [ n <> " = {"
    , "  url = \"" <> u <> "\";"
    , "  sha256 = \""
      <> case exitcode of
           ExitSuccess -> (T.strip (T.pack stdout))
           _ -> "0000000000000000000000000000000000000000000000000000000000000000"
      <> "\";"
    ]
    ++
    (map (\(k, v) -> "  " <> k <> " = \"" <> v <> "\";") (M.toList a))
    ++
    [ "};" ]

showNixSourceFiles :: [SourceFile] -> IO ()
showNixSourceFiles sources = do
  putStrLn "# Do not modify manually, auto generated with `generateSourceFiles.hs`"
  putStrLn "{"
  mapM
    (\sourceFile -> do
      nixSource <- showNixSource sourceFile
      putStr $ T.unpack $ T.unlines $ map (\x -> "  " <> x) nixSource
    )
    sources
  putStrLn "}"

#!/usr/bin/env nix-shell
#!nix-shell -i runhaskell --packages 'haskellPackages.ghcWithPackages (ps: [ps.aeson ps.aeson-pretty ps.directory ps.process ps.optparse-applicative])'

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Main where

import Options.Applicative
import System.FilePath (takeDirectory, (</>))
import System.Process (readProcess)
import Data.Aeson (object, (.=))
import Data.Aeson.Encode.Pretty (encodePretty', Config(..), defConfig, Indent(..), keyOrder)
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Map.Strict as Map
import Control.Monad (forM)
import qualified Data.Text as T

data Options = Options
  { scriptPath :: FilePath
  , channel    :: String
  }

optionsParser :: Parser Options
optionsParser = Options
  <$> argument str
      ( metavar "SCRIPT_PATH"
     <> help "The path to the script" )
  <*> argument channelReader
      ( metavar "CHANNEL"
     <> help "The release channel (main or stable)" )

channelReader :: ReadM String
channelReader = eitherReader $ \arg ->
  if arg `elem` ["main", "stable"]
      then Right arg
      else Left "CHANNEL must be one of: main, stable"

-- Custom configuration for pretty-printing JSON
prettyConfig :: Config
prettyConfig = defConfig
  { confIndent = Spaces 2
  , confCompare = keyOrder ["archMap", "fetchurlAttrSet", "platformList", "version"]
  }

main :: IO ()
main = do
  let opts = info (optionsParser <**> helper)
          ( fullDesc
         <> progDesc "Updates the sources-{main|stable}.json files based on the upstream release channel"
         <> header "update.hs - Haskell script with argument parsing" )

  -- Parse the command-line arguments
  Options {..} <- execParser opts

  -- Process the arguments
  let scriptDir = takeDirectory scriptPath
  let outputFile = scriptDir </> ("sources-" ++ channel ++ ".json")

  -- Fetch current version
  let baseUrl = "https://cli.upbound.io/" ++ channel
  currentVersion <- readProcess "curl" ["-s", baseUrl ++ "/current/version"] ""
  let version = filter (\x -> x /= 'v' && x /= '\n') currentVersion -- Remove the leading 'v' and the new line char

  -- Architecture mapping
  let archMapping = Map.fromList
        [ ("aarch64-darwin", "darwin_arm64")
        , ("x86_64-darwin", "darwin_amd64")
        , ("aarch64-linux", "linux_arm64")
        , ("x86_64-linux", "linux_amd64")
        ]

  -- Build platformList
  let platformList = Map.keys archMapping

  -- Build fetchurlAttrSet
  fetchurlAttrSet <- fmap Map.fromList $ forM ["docker-credential-up", "up"] $ \cmd -> do
    attrs <- forM (Map.toList archMapping) $ \(key, arch) -> do
      let url = baseUrl ++ "/v" ++ version ++ "/bundle/" ++ cmd ++ "/" ++ arch ++ ".tar.gz"
      _hash <- readProcess "nix-prefetch-url" [url] ""
      let hash = T.unpack $ T.strip $ T.pack _hash
      _sha256Hash <- readProcess "nix" ["hash", "convert", hash, "--hash-algo", "sha256"] ""
      let sha256Hash = T.unpack $ T.strip $ T.pack _sha256Hash
      return (key, object ["hash" .= sha256Hash, "url" .= url])
    return (cmd, object attrs)

  -- Write output to JSON
  let output = object
        [ "version" .= version
        , "platformList" .= platformList
        , "archMap" .= archMapping
        , "fetchurlAttrSet" .= fetchurlAttrSet
        ]
  BL.writeFile outputFile $ BL.snoc (encodePretty' prettyConfig output) '\n'

  putStrLn $ "Output written to: " ++ outputFile

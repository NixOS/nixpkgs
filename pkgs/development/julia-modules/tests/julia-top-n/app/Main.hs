{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE ViewPatterns #-}

module Main (main) where

import Control.Exception
import Control.Monad
import Data.Aeson as A hiding (Options, defaultOptions)
import qualified Data.Aeson.Key             as A
import qualified Data.Aeson.KeyMap          as HM
import qualified Data.ByteString.Lazy.Char8 as BL8
import qualified Data.List as L
import Data.String.Interpolate
import Data.Text as T
import qualified Data.Vector as V
import qualified Data.Yaml as Yaml
import GHC.Generics
import Options.Applicative
import System.Exit
import System.FilePath
import Test.Sandwich hiding (info)
import UnliftIO.MVar
import UnliftIO.Process


data Args = Args {
  countFilePath :: FilePath
  , topN :: Int
  , parallelism :: Int
  , juliaAttr :: Text
  }

argsParser :: Parser Args
argsParser = Args
  <$> strOption (long "count-file" <> short 'c' <> help "YAML file containing package names and counts")
  <*> option auto (long "top-n" <> short 'n' <> help "How many of the top packages to build" <> showDefault <> value 100 <> metavar "INT")
  <*> option auto (long "parallelism" <> short 'p' <> help "How many builds to run at once" <> showDefault <> value 10 <> metavar "INT")
  <*> strOption (long "julia-attr" <> short 'a' <> help "Which Julia attr to build with" <> showDefault <> value "julia" <> metavar "STRING")

data NameAndCount = NameAndCount {
  name :: Text
  , count :: Int
  , uuid :: Text
  } deriving (Show, Eq, Generic, FromJSON)

newtype JuliaPath = JuliaPath FilePath
  deriving Show

julia :: Label "julia" (MVar (Maybe JuliaPath))
julia = Label

main :: IO ()
main = do
  clo <- parseCommandLineArgs argsParser (return ())
  let Args {..} = optUserOptions clo

  namesAndCounts :: [NameAndCount] <- Yaml.decodeFileEither countFilePath >>= \case
    Left err -> throwIO $ userError ("Couldn't decode names and counts YAML file: " <> show err)
    Right x -> pure x

  runSandwichWithCommandLineArgs' defaultOptions argsParser $
    describe ("Building environments for top " <> show topN <> " Julia packages") $
      parallelN parallelism $
        forM_ (L.take topN namesAndCounts) $ \(NameAndCount {..}) ->
          introduce' (defaultNodeOptions { nodeOptionsVisibilityThreshold = 0 }) (T.unpack name) julia (newMVar Nothing) (const $ return ()) $ do
            it "Builds" $ do
              let cp = proc "nix" ["build", "--impure", "--no-link", "--json", "--expr"
                                  , [i|with import ../../../../. {}; #{juliaAttr}.withPackages ["#{name}"]|]
                                  ]
              output <- readCreateProcessWithLogging cp ""
              juliaPath <- case A.eitherDecode (BL8.pack output) of
                Right (A.Array ((V.!? 0) -> Just (A.Object (aesonLookup "outputs" -> Just (A.Object (aesonLookup "out" -> Just (A.String t))))))) -> pure (JuliaPath ((T.unpack t) </> "bin" </> "julia"))
                x -> expectationFailure ("Couldn't parse output: " <> show x)

              getContext julia >>= flip modifyMVar_ (const $ return (Just juliaPath))

            it "Uses" $ do
              getContext julia >>= readMVar >>= \case
                Nothing -> expectationFailure "Build step failed."
                Just (JuliaPath juliaPath) -> do
                  let cp = proc juliaPath ["-e", "using " <> T.unpack name]
                  createProcessWithLogging cp >>= waitForProcess >>= (`shouldBe` ExitSuccess)

aesonLookup :: Text -> HM.KeyMap v -> Maybe v
aesonLookup = HM.lookup . A.fromText

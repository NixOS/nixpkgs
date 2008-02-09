{-# OPTIONS_GHC -fglasgow-exts #-}
module Main where
import Distribution.InstalledPackageInfo (InstalledPackageInfo (..))
import Distribution.Package (showPackageId)
import System.FilePath
import System.Environment

usage = unlines [
  "<appname> in outDir"
  , "reads package db appname"
  , "and creates a package database for each contained package in outDir"
  , "" 
  , "The purpose is to be able to control availible packages to ensure purity in nix."
  , "Separating each package from the auomated ghc build process is to painful (for me)"
  ]

main = do
  args <- getArgs
  case args of
    [inFile, outDir] -> do
      -- prior to 6.9.x (when exactly) this must be InstalledPackageInfo only (not InstalledPackageInfo_ String) 
      -- (packagedb :: [InstalledPackageInfo_ String] ) <- fmap read $ readFile inFile
      (packagedb :: [InstalledPackageInfo] ) <- fmap read $ readFile inFile
      mapM_ (\pi -> let fn = outDir </> (showPackageId $ package pi) ++ ".conf"
                    in writeFile fn (show [pi])
            ) packagedb
    _ -> putStrLn usage

-- packages: filepath,Cabal,directory
{-# OPTIONS_GHC -fglasgow-exts #-}
module Main where
import Distribution.InstalledPackageInfo (InstalledPackageInfo (..))
import Distribution.Package (showPackageId)
import System.FilePath
import System.Environment
import System.Directory
import System.IO
import System.Exit
import Data.List

usage = unlines [
    " usage a) <app-name> split in_path out_path"
  , "       b) <app-anme> join out_path"
  , "This small helper executable servers two purposes:"
  , "a) split the main package db created by ghc installation into single libs"
  , "   so that nix can add them piecwise as needed to buildInputs"
  , "b) merge databases into one single file, so when building a library"
  , "   we can create one db containing all dependencies passed by GHC_PACKAGE_PATH"
  , "   I think this is a better solution than patching and mantaining cabal so"
  , "   that it support GHC_PACKAGE_PATH (not only by accident) ?"
  ]

mySplit :: (Eq Char) => [Char] ->[[ Char ]]
mySplit [] = []
mySplit list = let (l, l') = span (not . (`elem` ":;")) list
                    in l: mySplit (drop 1 l')

myReadFile f = doesFileExist f >>= \fe ->
    if fe then readFile f
          else do hPutStrLn stderr $ "unable to read file " ++ f
                  exitWith (ExitFailure 1)

main = do
  args <- getArgs
  case args of
    ["split", inFile, outDir] -> do
      -- prior to 6.9.x (when exactly) this must be InstalledPackageInfo only (not InstalledPackageInfo_ String) 
      -- (packagedb :: [InstalledPackageInfo_ String] ) <- fmap read $ myReadFile inFile
      (packagedb :: [InstalledPackageInfo] ) <- fmap read $ myReadFile inFile
      mapM_ (\pi -> let fn = outDir </> (showPackageId $ package pi) ++ ".conf"
                    in writeFile fn (show [pi])
            ) packagedb
    ["join", outpath] -> do
      getEnv "GHC_PACKAGE_PATH" >>= mapM myReadFile . nub . mySplit 
        >>= writeFile outpath . show . concat . map (read :: String -> [InstalledPackageInfo])
    _ -> putStrLn usage

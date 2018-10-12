module Main (main) where

import Distribution.Types.PackageDescription
import Distribution.Types.LocalBuildInfo
import Distribution.Simple.Configure
import Distribution.Types.TestSuite
import Distribution.Types.UnqualComponentName

main :: IO ()
main = do
  v <- getPersistBuildConfig "dist"
  mapM_ (putStrLn.unUnqualComponentName.testName) (testSuites $ localPkgDescr v)

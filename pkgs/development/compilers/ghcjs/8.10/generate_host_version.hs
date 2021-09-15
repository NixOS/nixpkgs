-- Generate the Host.hs and Version.hs as done by hadrian/src/Rules/Generate.hs

import GHC.Platform.Host
import GHC.Version

main = do
  writeFile "Version.hs" versionHs
  writeFile "Host.hs" platformHostHs

-- | Generate @Version.hs@ files.
versionHs :: String
versionHs = unlines
        [ "module GHC.Version where"
        , ""
        , "import Prelude -- See Note [Why do we import Prelude here?]"
        , ""
        , "cProjectGitCommitId   :: String"
        , "cProjectGitCommitId   = " ++ show cProjectGitCommitId
        , ""
        , "cProjectVersion       :: String"
        , "cProjectVersion       = " ++ show cProjectVersion
        , ""
        , "cProjectVersionInt    :: String"
        , "cProjectVersionInt    = " ++ show cProjectVersionInt
        , ""
        , "cProjectPatchLevel    :: String"
        , "cProjectPatchLevel    = " ++ show cProjectPatchLevel
        , ""
        , "cProjectPatchLevel1   :: String"
        , "cProjectPatchLevel1   = " ++ show cProjectPatchLevel1
        , ""
        , "cProjectPatchLevel2   :: String"
        , "cProjectPatchLevel2   = " ++ show cProjectPatchLevel2
        ]

-- | Generate @Platform/Host.hs@ files.
platformHostHs :: String
platformHostHs = unlines
        [ "module GHC.Platform.Host where"
        , ""
        , "import GHC.Platform"
        , ""
        , "cHostPlatformArch :: Arch"
        , "cHostPlatformArch = " ++ show cHostPlatformArch
        , ""
        , "cHostPlatformOS   :: OS"
        , "cHostPlatformOS   = " ++ show cHostPlatformOS
        , ""
        , "cHostPlatformMini :: PlatformMini"
        , "cHostPlatformMini = PlatformMini"
        , "  { platformMini_arch = cHostPlatformArch"
        , "  , platformMini_os = cHostPlatformOS"
        , "  }"
        ]

# `libraries/ghc-boot/Setup.hs` generates `GHC.Version` and
# `GHC.Platform.Host`, and takes their values from
#
#     lookupEnv "HADRIAN_SETTINGS" >>= \case
#       Just settings -> pure $ Left $ read settings
#       Nothing       -> Right . read <$> getProgramOutput normal ghc ["--info"]
#
# Without the variable it asks the *booting* compiler, so a 9.14 tree built
# by a 9.10 bootstrap produces a compiler that reports `version 9.10.3`.
# The variable is upstream's own escape hatch for exactly this; the keys
# below are the `kh` names `getSetting` looks up in the `Left` case.
{
  lib,
  stdenv,
  ghcSrc,
  ghcArch,
  ghcOS,
  ...
}:
_: _:
let
  p = stdenv.hostPlatform;
  bootSettings = {
    hostPlatformArch = ghcArch p;
    hostPlatformOS = ghcOS p;
    cProjectGitCommitId = "";
    cProjectVersion = ghcSrc.release_version;
    cProjectVersionInt = ghcSrc.projectVersionInt;
    cProjectPatchLevel = ghcSrc.projectPatchLevel1;
    cProjectPatchLevel1 = ghcSrc.projectPatchLevel1;
    cProjectPatchLevel2 = ghcSrc.projectPatchLevel2;
  };
in
{
  # `read` of a `[(String, String)]`, which is what `Setup.hs` expects.
  # Writing the format rather than patching `Setup.hs` to accept JSON is
  # what keeps this a stock tree: every value here is a version component
  # or an `ArchOS` constructor, so none of them contains a quote or a
  # backslash and `show` is just the obvious quoting.
  #
  # This is *not* `lib/settings.json`. It never reaches the installed
  # compiler -- it is consumed during this package's build, to generate
  # `GHC.Version` and `GHC.Platform.Host`, and the keys are hadrian's
  # own names rather than settings-file names.
  env.HADRIAN_SETTINGS =
    "["
    + lib.concatMapStringsSep "," (n: ''("${n}","${toString bootSettings.${n}}")'') (
      lib.attrNames bootSettings
    )
    + "]";
}

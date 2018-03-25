# This is the generic `Setup` installer for haskell packages.
#
# For now we just build the `Setup.hs` against the 
{ stdenv, ghc, lib }:
{ setupHaskellDepends ? []
, setupHs ? ''
  import Distribution.Simple
  main = defaultMain
''
} @ args:
stdenv.mkDerivation (rec {
  name = "Setup";

  phases = [ "buildPhase" ];

  buildInputs = [ ghc ] ++ setupHaskellDepends;
  LANG = "en_US.UTF-8";

  # build up the package database, with the additional dependencies 
  preBuild = ''
    setupPackageConfDir="$TMPDIR/setup-package.conf.d"
    mkdir -p "$setupPackageConfDir"

    # Add the setupHaskellDepends to a custom package-db,
    # which ghc will be provided with.

    for p in ${lib.escapeShellArgs setupHaskellDepends}; do
      if [ -d "$p/lib/${ghc.name}/package.conf.d" ]; then
        cp -f "$p/lib/${ghc.name}/package.conf.d/"*.conf $setupPackageConfDir/
      fi
    done
    ${ghc.targetPrefix}ghc-pkg --package-db="$setupPackageConfDir" recache
  '';

  buildPhase = ''
    runHook preBuild
    echo "$setupPackageConfDir"
    mkdir -p $out
    GHC_PACKAGE_PATH="$setupPackageConfDir:" ghc --make -o $out/Setup -odir $TMPDIR -hidir $TMPDIR ${builtins.toFile "Setup.hs" setupHs}
    runHook postBuild
  '';
})

{ stdenv, ghc, packages, buildEnv, makeWrapper, ignoreCollisions ? false }:

# This wrapper works only with GHC 6.12 or later.
assert stdenv.lib.versionOlder "6.12" ghc.version;

# It's probably a good idea to include the library "ghc-paths" in the
# compiler environment, because we have a specially patched version of
# that package in Nix that honors these environment variables
#
#   NIX_GHC
#   NIX_GHCPKG
#   NIX_GHC_DOCDIR
#   NIX_GHC_LIBDIR
#
# instead of hard-coding the paths. The wrapper sets these variables
# appropriately to configure ghc-paths to point back to the wrapper
# instead of to the pristine GHC package, which doesn't know any of the
# additional libraries.
#
# A good way to import the environment set by the wrapper below into
# your shell is to add the following snippet to your ~/.bashrc:
#
#   if [ -e ~/.nix-profile/bin/ghc ]; then
#     eval $(grep export ~/.nix-profile/bin/ghc)
#   fi

let
  ghc761OrLater = stdenv.lib.versionOlder "7.6.1" ghc.version;
  packageDBFlag = if ghc761OrLater then "--global-package-db" else "--global-conf";
  libDir        = "$out/lib/ghc-${ghc.version}";
  docDir        = "$out/share/doc/ghc/html";
  packageCfgDir = "${libDir}/package.conf.d";
  isHaskellPkg  = x: (x ? pname) && (x ? version);
in
if packages == [] then ghc else
buildEnv {
  name = "haskell-env-${ghc.name}";
  paths = stdenv.lib.filter isHaskellPkg (stdenv.lib.closePropagation packages) ++ [ghc];
  inherit ignoreCollisions;
  postBuild = ''
    . ${makeWrapper}/nix-support/setup-hook

    for prg in ghc ghci ghc-${ghc.version} ghci-${ghc.version}; do
      rm -f $out/bin/$prg
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg         \
        --add-flags '"-B$NIX_GHC_LIBDIR"'               \
        --set "NIX_GHC"        "$out/bin/ghc"           \
        --set "NIX_GHCPKG"     "$out/bin/ghc-pkg"       \
        --set "NIX_GHC_DOCDIR" "${docDir}"              \
        --set "NIX_GHC_LIBDIR" "${libDir}"
    done

    for prg in runghc runhaskell; do
      rm -f $out/bin/$prg
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg         \
        --add-flags "-f $out/bin/ghc"                   \
        --set "NIX_GHC"        "$out/bin/ghc"           \
        --set "NIX_GHCPKG"     "$out/bin/ghc-pkg"       \
        --set "NIX_GHC_DOCDIR" "${docDir}"              \
        --set "NIX_GHC_LIBDIR" "${libDir}"
    done

    for prg in ghc-pkg ghc-pkg-${ghc.version}; do
      rm -f $out/bin/$prg
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg --add-flags "${packageDBFlag}=${packageCfgDir}"
    done

    $out/bin/ghc-pkg recache
  '';
}

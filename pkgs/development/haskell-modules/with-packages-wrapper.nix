{ runCommand, lib, version, meta, withPackagesBuilder, packages, ignoreCollisions ? false }:

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

runCommand "buildHaskellEnv" { inherit version meta; preferLocalBuild = true; }
(withPackagesBuilder {
  paths = lib.filter (x: (x ? pname) && (x ? version)) (lib.closePropagation packages);
  inherit ignoreCollisions;
})

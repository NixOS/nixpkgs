# Exposed as cudaPackages.backendStdenv.
# This is what nvcc uses as a backend,
# and it has to be an officially supported one (e.g. gcc11 for cuda11).
#
# It, however, propagates current stdenv's libstdc++ to avoid "GLIBCXX_* not found errors"
# when linked with other C++ libraries.
# E.g. for cudaPackages_11_8 we use gcc11 with gcc12's libstdc++
# Cf. https://github.com/NixOS/nixpkgs/pull/218265 for context
{
  cudaVersion,
  lib,
  nvccCompatibilities,
  pkgs,
  stdenv,
  stdenvAdapters,
}:

let
  gccMajorVersion = nvccCompatibilities.${cudaVersion}.gccMaxMajorVersion;
  cudaStdenv = stdenvAdapters.useLibsFrom stdenv pkgs."gcc${gccMajorVersion}Stdenv";
  passthruExtra = {
    # cudaPackages.backendStdenv.nixpkgsCompatibleLibstdcxx has been removed,
    # if you need it you're likely doing something wrong. There has been a
    # warning here for a month or so. Now we can no longer return any
    # meaningful value in its place and drop the attribute entirely.
  };
  assertCondition = true;
in

# TODO: Consider testing whether we in fact use the newer libstdc++

lib.extendDerivation assertCondition passthruExtra cudaStdenv

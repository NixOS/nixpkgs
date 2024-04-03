{
  lib,
  nvccCompatibilities,
  cudaVersion,
  pkgs,
  overrideCC,
  stdenv,
  wrapCCWith,
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

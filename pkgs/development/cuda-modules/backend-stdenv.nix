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
    nixpkgsCompatibleLibstdcxx = lib.warn "cudaPackages.backendStdenv.nixpkgsCompatibleLibstdcxx is misnamed, deprecated, and will be removed after 24.05" cudaStdenv.cc.cxxStdlib.package;
    # cc already exposed
  };
  assertCondition = true;
in

  /* TODO: Consider testing whether we in fact use the newer libstdc++ */

lib.extendDerivation assertCondition passthruExtra cudaStdenv

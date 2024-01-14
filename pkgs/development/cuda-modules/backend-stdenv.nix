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

# We should use libstdc++ at least as new as nixpkgs' stdenv's one.
assert let
  cxxStdlibCuda = cudaStdenv.cc.cxxStdlib.package;
  cxxStdlibNixpkgs = stdenv.cc.cxxStdlib.package;
in
((stdenv.cc.cxxStdlib.kind or null) == "libstdc++")
-> lib.versionAtLeast cxxStdlibCuda.version cxxStdlibNixpkgs.version;

lib.extendDerivation assertCondition passthruExtra cudaStdenv

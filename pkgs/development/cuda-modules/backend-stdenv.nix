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

/*
# We should use libstdc++ at least as new as nixpkgs' stdenv's one.
assert let
  cxxStdlibCuda = cudaStdenv.cc.cxxStdlib.package;
  cxxStdlibNixpkgs = stdenv.cc.cxxStdlib.package;

  # Expose the C++ standard library we're using. See the comments on "General
  # libc++ support". This is also relevant when using older gcc than the
  # stdenv's, as may be required e.g. by CUDAToolkit's nvcc.
  cxxStdlib = libcxx:
    let
      givenLibcxx = libcxx != null && (libcxx.isLLVM or false);
      givenGccForLibs = libcxx != null && !(libcxx.isLLVM or false) && (libcxx.isGNU or false);
      libcxx_solib = "${lib.getLib libcxx}/lib";
    in
      if (!givenLibcxx) && givenGccForLibs then
        { kind = "libstdc++"; package = libcxx; solib = libcxx_solib; }
      else if givenLibcxx then
        { kind = "libc++"; package = libcxx;  solib = libcxx_solib;}
      else
        # We're probably using the `libstdc++` that came with our `gcc`.
        # TODO: this is maybe not always correct?
        # TODO: what happens when `nativeTools = true`?
        { kind = "libstdc++"; package = cc; solib = cc_solib; }
  ;
in
((stdenv.cc.cxxStdlib.kind or null) == "libstdc++")
-> lib.versionAtLeast cxxStdlibCuda.version cxxStdlibNixpkgs.version;
*/

lib.extendDerivation assertCondition passthruExtra cudaStdenv

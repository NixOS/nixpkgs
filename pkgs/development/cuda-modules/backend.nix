# The backend runs on HOST and emits for TARGET, just like any packaged compiler.
# Consumers obtain their BUILD -> HOST backend through normal input splicing.
{
  _cuda,
  backendCC,
  cudaMajorMinorVersion,
  lib,
  pkgs,
  stdenv,
  stdenvAdapters,
  targetPackages,
}:
let
  cc = targetPackages.stdenv.cc;
  compilerName =
    if cc.isGNU then
      "gcc"
    else if cc.isClang then
      "clang"
    else
      throw "cudaPackages.backendCC: unsupported host compiler: ${cc.name}";
  versions = _cuda.db.nvccCompatibilities.${cudaMajorMinorVersion}.${compilerName};
  supported =
    lib.versionAtLeast (lib.versions.major cc.version) versions.minMajorVersion
    && lib.versionAtLeast versions.maxMajorVersion (lib.versions.major cc.version);
  candidates =
    map
      (
        version:
        if compilerName == "gcc" then
          pkgs."gcc${toString version}" or null
        else
          pkgs."llvmPackages_${toString version}".clang or null
      )
      (
        lib.reverseList (
          lib.range (lib.toIntBase10 versions.minMajorVersion) (lib.toIntBase10 versions.maxMajorVersion)
        )
      );
  selected = lib.findFirst (candidate: candidate != null) null candidates;
in
{
  cc =
    if supported then
      cc
    else
      assert lib.assertMsg (selected != null)
        "backendCC: no supported host compiler found (tried ${compilerName} ${versions.minMajorVersion} to ${versions.maxMajorVersion})";
      if cc.isClang then
        # Clang's wrapper already knows its C++ runtime. Replace only the compiler:
        # Clang itself is not a valid gccForLibs provider.
        cc.override { cc = selected.cc; }
      else
        # GCC supplies its own C++ runtime. Retain the current runtime so CUDA code
        # can link against packages built with the ordinary stdenv.
        selected.override {
          useCcForLibs = true;
          gccForLibs = cc.cc;
        };

  # Resolve the backend's BUILD -> HOST splice before nesting it under cc:
  # arbitrary derivation attributes do not inherit their enclosing splices.
  stdenv = stdenvAdapters.overrideCC stdenv (backendCC.__spliced.buildHost or backendCC);
}

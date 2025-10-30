# This is what nvcc uses as a backend,
# and it has to be an officially supported one (e.g. gcc14 for cuda12).
#
# It, however, propagates current stdenv's libstdc++ to avoid "GLIBCXX_* not found errors"
# when linked with other C++ libraries.
# E.g. for cudaPackages_12_9 we use gcc14 with gcc's libstdc++
# Cf. https://github.com/NixOS/nixpkgs/pull/218265 for context
{
  _cuda,
  config,
  cudaMajorMinorVersion,
  lib,
  pkgs,
  stdenv,
  stdenvAdapters,
}:
let
  inherit (builtins)
    throw
    toJSON
    toString
    ;
  inherit (_cuda.db) allSortedCudaCapabilities cudaCapabilityToInfo nvccCompatibilities;
  inherit (_cuda.lib)
    _cudaCapabilityIsDefault
    _cudaCapabilityIsSupported
    _mkMetaProblems
    getRedistSystem
    mkVersionedName
    ;
  inherit (lib)
    assertMsg
    extendDerivation
    filter
    findFirst
    flip
    intersectLists
    pipe
    range
    reverseList
    subtractLists
    toIntBase10
    versionAtLeast
    versionOlder
    ;
  inherit (lib.versions) major;

  passthruExtra = {

    # NOTE: All of these attributes are internal details subject to removal!

    supportedByNvcc = maybeBackendStdenv.valid;

    # The Nix system of the host platform.
    hostNixSystem = stdenv.hostPlatform.system;

    # The Nix system of the host platform for the CUDA redistributable.
    hostRedistSystem = getRedistSystem {
      inherit (passthruExtra) cudaCapabilities;
      inherit cudaMajorMinorVersion;
      inherit (stdenv.hostPlatform) system;
    };

    # Sets whether packages should be built with forward compatibility.
    # TODO(@connorbaker): If the requested CUDA capabilities are not supported by the current CUDA version,
    # should we throw an evaluation warning and build with forward compatibility?
    cudaForwardCompat = config.cudaForwardCompat or true;

    # CUDA capabilities which are supported by the current CUDA version.
    supportedCudaCapabilities = filter (
      cudaCapability:
      _cudaCapabilityIsSupported cudaMajorMinorVersion cudaCapabilityToInfo.${cudaCapability}
    ) allSortedCudaCapabilities;

    # Find the default set of capabilities for this CUDA version using the list of supported capabilities.
    # Includes only baseline capabilities.
    defaultCudaCapabilities = filter (
      cudaCapability:
      _cudaCapabilityIsDefault cudaMajorMinorVersion cudaCapabilityToInfo.${cudaCapability}
    ) passthruExtra.supportedCudaCapabilities;

    # The resolved requested or default CUDA capabilities.
    cudaCapabilities =
      if config.cudaCapabilities or [ ] != [ ] then
        config.cudaCapabilities
      else
        passthruExtra.defaultCudaCapabilities;

    jetsonCudaCapabilities = filter (
      cudaCapability: cudaCapabilityToInfo.${cudaCapability}.isJetson
    ) allSortedCudaCapabilities;

    # Requested Jetson CUDA capabilities.
    requestedJetsonCudaCapabilities = intersectLists passthruExtra.jetsonCudaCapabilities passthruExtra.cudaCapabilities;

    # Whether the requested CUDA capabilities include Jetson CUDA capabilities.
    hasJetsonCudaCapability = passthruExtra.requestedJetsonCudaCapabilities != [ ];

    # Whether the requested CUDA capabilities include family-specific CUDA capabilities.
    hasFamilySpecificCudaCapability = passthruExtra.requestedFamilySpecificCudaCapabilities != [ ];
  };

  # TODO(@connorbaker): Seems like `stdenvAdapters.useLibsFrom` breaks clangStdenv's ability to find header files.
  # To reproduce: use `nix shell .#cudaPackages_12_6.backendClangStdenv.cc` since CUDA 12.6 supports at most Clang
  # 18, but the current stdenv uses Clang 19, requiring this code path.
  # With:
  #
  # ```cpp
  # #include <cmath>
  #
  # int main() {
  #     double value = 0.5;
  #     double result = std::sin(value);
  #     return 0;
  # }
  # ```
  #
  # we get:
  #
  # ```console
  # $ clang++ ./main.cpp
  # ./main.cpp:1:10: fatal error: 'cmath' file not found
  #     1 | #include <cmath>
  #       |          ^~~~~~~
  # 1 error generated.
  # ```
  # TODO(@connorbaker): Seems like even using unmodified `clangStdenv` causes issues -- saxpy fails to build CMake
  # errors during CUDA compiler identification about invalid redefinitions of things like `realpath`.
  maybeBackendStdenv =
    let
      hostCCName =
        if stdenv.cc.isGNU then
          "gcc"
        else if stdenv.cc.isClang then
          "clang"
        else
          throw "cudaPackages.backendStdenv: unsupported host compiler: ${stdenv.cc.name}";

      versions = nvccCompatibilities.${cudaMajorMinorVersion}.${hostCCName};

      stdenvIsSupportedVersion =
        versionAtLeast (major stdenv.cc.version) versions.minMajorVersion
        && versionAtLeast versions.maxMajorVersion (major stdenv.cc.version);

      maybeGetVersionedCC =
        if hostCCName == "gcc" then
          version: pkgs."gcc${version}Stdenv" or null
        else
          version: pkgs."llvmPackages_${version}".stdenv or null;

      maybeHostStdenv =
        pipe (range (toIntBase10 versions.minMajorVersion) (toIntBase10 versions.maxMajorVersion))
          [
            # Convert integers to strings.
            (map toString)
            # Prefer the highest available version.
            reverseList
            # Map to the actual stdenvs or null if unavailable.
            (map maybeGetVersionedCC)
            # Get the first available version.
            (findFirst (x: x != null) null)
          ];
    in
    # The actual error messages are generated in cuda_nvcc based on backendStdenv.supportedByNvcc
    rec {
      valid =
        maybeHostStdenv != null
        && stdenvIsSupportedVersion
        && passthruExtra.hostRedistSystem != "unsupported";
      value = if valid then stdenvAdapters.useLibsFrom stdenv maybeHostStdenv else stdenv;
    };
in
extendDerivation true passthruExtra maybeBackendStdenv.value

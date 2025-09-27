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
    _evaluateAssertions
    getRedistSystem
    mkVersionedName
    ;
  inherit (lib)
    addErrorContext
    assertMsg
    extendDerivation
    filter
    findFirst
    intersectLists
    pipe
    range
    reverseList
    subtractLists
    toIntBase10
    versionAtLeast
    ;
  inherit (lib.versions) major;

  # NOTE: By virtue of processing a sorted list (allSortedCudaCapabilities), our groups will be sorted.

  architectureSpecificCudaCapabilities = filter (
    cudaCapability: cudaCapabilityToInfo.${cudaCapability}.isArchitectureSpecific
  ) allSortedCudaCapabilities;

  familySpecificCudaCapabilities = filter (
    cudaCapability: cudaCapabilityToInfo.${cudaCapability}.isFamilySpecific
  ) allSortedCudaCapabilities;

  jetsonCudaCapabilities = filter (
    cudaCapability: cudaCapabilityToInfo.${cudaCapability}.isJetson
  ) allSortedCudaCapabilities;

  passthruExtra = {
    nvccHostCCMatchesStdenvCC = backendStdenv.cc == stdenv.cc;

    # TODO(@connorbaker): Does it make sense to expose the `stdenv` we were called with and the `stdenv` selected
    # prior to using `stdenvAdapters.useLibsFrom`?

    # The Nix system of the host platform.
    hostNixSystem = stdenv.hostPlatform.system;

    # The Nix system of the host platform for the CUDA redistributable.
    hostRedistSystem = getRedistSystem passthruExtra.hasJetsonCudaCapability stdenv.hostPlatform.system;

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

    # Requested architecture-specific CUDA capabilities.
    requestedArchitectureSpecificCudaCapabilities = intersectLists architectureSpecificCudaCapabilities passthruExtra.cudaCapabilities;

    # Whether the requested CUDA capabilities include architecture-specific CUDA capabilities.
    hasArchitectureSpecificCudaCapability =
      passthruExtra.requestedArchitectureSpecificCudaCapabilities != [ ];

    # Requested family-specific CUDA capabilities.
    requestedFamilySpecificCudaCapabilities = intersectLists familySpecificCudaCapabilities passthruExtra.cudaCapabilities;

    # Whether the requested CUDA capabilities include family-specific CUDA capabilities.
    hasFamilySpecificCudaCapability = passthruExtra.requestedFamilySpecificCudaCapabilities != [ ];

    # Requested Jetson CUDA capabilities.
    requestedJetsonCudaCapabilities = intersectLists jetsonCudaCapabilities passthruExtra.cudaCapabilities;

    # Whether the requested CUDA capabilities include Jetson CUDA capabilities.
    hasJetsonCudaCapability = passthruExtra.requestedJetsonCudaCapabilities != [ ];
  };

  assertions =
    let
      # Jetson devices cannot be targeted by the same binaries which target non-Jetson devices. While
      # NVIDIA provides both `linux-aarch64` and `linux-sbsa` packages, which both target `aarch64`,
      # they are built with different settings and cannot be mixed.
      jetsonMesssagePrefix = "Jetson CUDA capabilities (${toJSON passthruExtra.requestedJetsonCudaCapabilities})";

      # Remove all known capabilities from the user's list to find unrecognized capabilities.
      unrecognizedCudaCapabilities = subtractLists allSortedCudaCapabilities passthruExtra.cudaCapabilities;

      # Remove all supported capabilities from the user's list to find unsupported capabilities.
      unsupportedCudaCapabilities = subtractLists passthruExtra.supportedCudaCapabilities passthruExtra.cudaCapabilities;
    in
    [
      {
        message = "Unrecognized CUDA capabilities: ${toJSON unrecognizedCudaCapabilities}";
        assertion = unrecognizedCudaCapabilities == [ ];
      }
      {
        message = "Unsupported CUDA capabilities: ${toJSON unsupportedCudaCapabilities}";
        assertion = unsupportedCudaCapabilities == [ ];
      }
      {
        message =
          "${jetsonMesssagePrefix} require hostPlatform (currently ${passthruExtra.hostNixSystem}) "
          + "to be aarch64-linux";
        assertion = passthruExtra.hasJetsonCudaCapability -> passthruExtra.hostNixSystem == "aarch64-linux";
      }
      {
        message =
          let
            # Find the capabilities which are not Jetson capabilities.
            requestedNonJetsonCudaCapabilities = subtractLists (
              passthruExtra.requestedJetsonCudaCapabilities
              ++ passthruExtra.requestedArchitectureSpecificCudaCapabilities
              ++ passthruExtra.requestedFamilySpecificCudaCapabilities
            ) passthruExtra.cudaCapabilities;
          in
          "${jetsonMesssagePrefix} cannot be specified with non-Jetson capabilities "
          + "(${toJSON requestedNonJetsonCudaCapabilities})";
        assertion =
          passthruExtra.hasJetsonCudaCapability
          -> passthruExtra.requestedJetsonCudaCapabilities == passthruExtra.cudaCapabilities;
      }
    ];

  assertCondition = addErrorContext "while evaluating ${mkVersionedName "cudaPackages" cudaMajorMinorVersion}.backendStdenv" (
    _evaluateAssertions assertions
  );

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
  backendStdenv =
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
    # If the current stdenv's compiler version is compatible, or we're on an unsupported host system, use stdenv
    # directly.
    # If we're on an unsupported host system (like darwin), there's not much else we can do, but we should not break
    # evaluation on unsupported systems.
    if stdenvIsSupportedVersion || passthruExtra.hostRedistSystem == "unsupported" then
      stdenv
    # Otherwise, try to find a compatible stdenv.
    else
      assert assertMsg (maybeHostStdenv != null)
        "backendStdenv: no supported host compiler found (tried ${hostCCName} ${versions.minMajorVersion} to ${versions.maxMajorVersion})";
      stdenvAdapters.useLibsFrom stdenv maybeHostStdenv;
in
# TODO: Consider testing whether we in fact use the newer libstdc++
extendDerivation assertCondition passthruExtra backendStdenv

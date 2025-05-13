# NOTE(@SomeoneSerge): Originally implemented by @ConnorBaker, git-blame broken during refactoring
# TODO(@SomeoneSerge): Verify all definitions have consumers; deduplciate with the rest of _cuda

{ _cuda, lib }:
let
  inherit (lib.lists) filter intersectLists;
  inherit (_cuda.db) cudaCapabilityToInfo allSortedCudaCapabilities;
  inherit (_cuda.lib)
    _cudaCapabilityIsDefault
    _cudaCapabilityIsSupported
    getRedistSystem
    ;
  inherit (_cuda.lib)
    _evaluateAssertions
    mkVersionedName
    ;
  inherit (builtins) toJSON;
  inherit (lib) addErrorContext;
  inherit (lib.lists) subtractLists;

  listOr = lst: default: if lst == [ ] then default else lst;

in

{
  stdenv,
  config,
  cudaMajorMinorVersion,
}:
let
  flags = {

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

    # The Nix system of the host platform.
    hostNixSystem = stdenv.hostPlatform.system;

    # The Nix system of the host platform for the CUDA redistributable.
    hostRedistSystem = getRedistSystem flags.includeJetson stdenv.hostPlatform.system;

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
    ) flags.supportedCudaCapabilities;

    # The resolved requested or default CUDA capabilities.
    cudaCapabilities = listOr config.cudaCapabilities or [ ] flags.defaultCudaCapabilities;

    # Requested architecture-specific CUDA capabilities.
    requestedArchitectureSpecificCudaCapabilities = intersectLists flags.architectureSpecificCudaCapabilities flags.cudaCapabilities;

    # Whether the requested CUDA capabilities include architecture-specific CUDA capabilities.
    hasArchitectureSpecificCudaCapability = flags.requestedArchitectureSpecificCudaCapabilities != [ ];

    # Requested family-specific CUDA capabilities.
    requestedFamilySpecificCudaCapabilities = intersectLists flags.familySpecificCudaCapabilities flags.cudaCapabilities;

    # Whether the requested CUDA capabilities include family-specific CUDA capabilities.
    hasFamilySpecificCudaCapability = flags.requestedFamilySpecificCudaCapabilities != [ ];

    # Requested Jetson CUDA capabilities.
    requestedJetsonCudaCapabilities = intersectLists flags.jetsonCudaCapabilities flags.cudaCapabilities;

    # Whether the requested CUDA capabilities include Jetson CUDA capabilities.
    includeJetson = flags.requestedJetsonCudaCapabilities != [ ];
  };
  assertions =
    let
      # Jetson devices cannot be targeted by the same binaries which target non-Jetson devices. While
      # NVIDIA provides both `linux-aarch64` and `linux-sbsa` packages, which both target `aarch64`,
      # they are built with different settings and cannot be mixed.
      jetsonMesssagePrefix = "Jetson CUDA capabilities (${toJSON flags.requestedJetsonCudaCapabilities})";

      # Remove all known capabilities from the user's list to find unrecognized capabilities.
      unrecognizedCudaCapabilities = subtractLists allSortedCudaCapabilities flags.cudaCapabilities;

      # Remove all supported capabilities from the user's list to find unsupported capabilities.
      unsupportedCudaCapabilities = subtractLists flags.supportedCudaCapabilities flags.cudaCapabilities;
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
          "${jetsonMesssagePrefix} require hostPlatform (currently ${flags.hostNixSystem}) "
          + "to be aarch64-linux";
        assertion = flags.includeJetson -> flags.hostNixSystem == "aarch64-linux";
      }
      {
        message =
          let
            # Find the capabilities which are not Jetson capabilities.
            requestedNonJetsonCudaCapabilities = subtractLists (
              flags.requestedJetsonCudaCapabilities
              ++ flags.requestedArchitectureSpecificCudaCapabilities
              ++ flags.requestedFamilySpecificCudaCapabilities
            ) flags.cudaCapabilities;
          in
          "${jetsonMesssagePrefix} cannot be specified with non-Jetson capabilities "
          + "(${toJSON requestedNonJetsonCudaCapabilities})";
        assertion = flags.includeJetson -> flags.requestedJetsonCudaCapabilities == flags.cudaCapabilities;
      }
    ];

  assertCondition = addErrorContext "while evaluating ${mkVersionedName "cudaPackages" cudaMajorMinorVersion}.backendStdenv" (
    _evaluateAssertions assertions
  );
in
assert assertCondition;
flags

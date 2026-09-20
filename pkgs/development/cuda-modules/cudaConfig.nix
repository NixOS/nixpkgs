# Resolve GPU configuration independently of compilers and package-set splicing.
{
  _cuda,
  config,
  cudaMajorMinorVersion,
  lib,
}:
let
  inherit (builtins) toJSON;
  inherit (_cuda.db) allSortedCudaCapabilities cudaCapabilityToInfo;
  inherit (_cuda.lib)
    _cudaCapabilityIsDefault
    _cudaCapabilityIsSupported
    _getJetsonMinSbsaCapability
    _mkFailedAssertionsString
    mkVersionedName
    ;
  inherit (lib)
    assertMsg
    filter
    flip
    intersectLists
    subtractLists
    versionOlder
    ;

  # NOTE: By virtue of processing a sorted list (allSortedCudaCapabilities), our groups will be sorted.

  jetsonCudaCapabilities = filter (
    cudaCapability: cudaCapabilityToInfo.${cudaCapability}.isJetson
  ) allSortedCudaCapabilities;

  cudaConfig = {
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
    ) cudaConfig.supportedCudaCapabilities;

    # The resolved requested or default CUDA capabilities.
    cudaCapabilities =
      if config.cudaCapabilities or [ ] != [ ] then
        config.cudaCapabilities
      else
        cudaConfig.defaultCudaCapabilities;

    # Requested Jetson CUDA capabilities.
    requestedJetsonCudaCapabilities = intersectLists jetsonCudaCapabilities cudaConfig.cudaCapabilities;

    # Whether the requested CUDA capabilities include Jetson CUDA capabilities.
    hasJetsonCudaCapability = cudaConfig.requestedJetsonCudaCapabilities != [ ];
  };

  assertions =
    let
      # Jetson devices (pre-Orin) cannot be targeted by the same binaries which target non-Jetson devices. While
      # NVIDIA provides both `linux-aarch64` and `linux-sbsa` packages, which both target `aarch64`,
      # they are built with different settings and cannot be mixed.
      sbsaJetsonCapability = _getJetsonMinSbsaCapability cudaMajorMinorVersion;
      preSbsaJetsonCudaCapabilities = filter (flip versionOlder sbsaJetsonCapability) cudaConfig.requestedJetsonCudaCapabilities;

      # Remove all known capabilities from the user's list to find unrecognized capabilities.
      unrecognizedCudaCapabilities = subtractLists allSortedCudaCapabilities cudaConfig.cudaCapabilities;

      # Capabilities which are too old for this CUDA version.
      tooOldCudaCapabilities = filter (
        cap:
        let
          # This can be null!
          maybeMax = cudaCapabilityToInfo.${cap}.maxCudaMajorMinorVersion;
        in
        maybeMax != null && lib.versionOlder maybeMax cudaMajorMinorVersion
      ) cudaConfig.cudaCapabilities;

      # Capabilities which are too new for this CUDA version.
      tooNewCudaCapabilities = filter (
        cap: lib.versionOlder cudaMajorMinorVersion cudaCapabilityToInfo.${cap}.minCudaMajorMinorVersion
      ) cudaConfig.cudaCapabilities;
    in
    [
      {
        message = "Requested unrecognized CUDA capabilities: ${toJSON unrecognizedCudaCapabilities}";
        assertion = unrecognizedCudaCapabilities == [ ];
      }
      {
        message = "Requested CUDA capabilities which are too old for CUDA ${cudaMajorMinorVersion}: ${toJSON tooOldCudaCapabilities}";
        assertion = tooOldCudaCapabilities == [ ];
      }
      {
        message = "Requested CUDA capabilities which are too new for CUDA ${cudaMajorMinorVersion}: ${toJSON tooNewCudaCapabilities}";
        assertion = tooNewCudaCapabilities == [ ];
      }
      {
        message =
          "Requested pre-SBSA (${sbsaJetsonCapability}) Jetson CUDA capabilities (${toJSON preSbsaJetsonCudaCapabilities}) cannot be "
          + "specified with other capabilities (${toJSON (subtractLists preSbsaJetsonCudaCapabilities cudaConfig.cudaCapabilities)})";
        assertion =
          # If there are preSbsaJetsonCudaCapabilities, they must be the only requested capabilities.
          preSbsaJetsonCudaCapabilities != [ ]
          -> preSbsaJetsonCudaCapabilities == cudaConfig.cudaCapabilities;
      }
    ];

  failedAssertionsString = _mkFailedAssertionsString assertions;

in
assert assertMsg (failedAssertionsString == "")
  "${mkVersionedName "cudaPackages" cudaMajorMinorVersion}.cudaConfig has failed assertions:${failedAssertionsString}";
cudaConfig

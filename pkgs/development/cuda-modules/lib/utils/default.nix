{ cudaLib, lib }:
{
  # See ./assertions.nix for documentation.
  inherit (import ./assertions.nix { inherit cudaLib lib; })
    _evaluateAssertions
    _mkFailedAssertionsString
    _mkMissingPackagesAssertions
    ;

  # See ./cuda.nix for documentation.
  inherit (import ./cuda.nix { inherit lib; })
    _cudaCapabilityIsDefault
    _cudaCapabilityIsSupported
    _mkCudaVariant
    allowUnfreeCudaPredicate
    ;

  # See ./meta.nix for documentation.
  inherit (import ./meta.nix { inherit cudaLib lib; })
    _mkMetaBadPlatforms
    _mkMetaBroken
    ;

  # See ./redist.nix for documentation.
  inherit (import ./redist.nix { inherit cudaLib lib; })
    _redistSystemIsSupported
    getNixSystems
    getRedistSystem
    mkRedistUrl
    ;

  # See ./strings.nix for documentation.
  inherit (import ./strings.nix { inherit cudaLib lib; })
    dotsToUnderscores
    dropDots
    formatCapabilities
    mkCmakeCudaArchitecturesString
    mkGencodeFlag
    mkRealArchitecture
    mkVersionedName
    mkVirtualArchitecture
    ;

  # See ./versions.nix for documentation.
  inherit (import ./versions.nix { inherit cudaLib lib; })
    majorMinorPatch
    trimComponents
    ;
}

{
  _cuda,
  lib,
}:
{
  # See ./assertions.nix for documentation.
  inherit (import ./assertions.nix { inherit _cuda lib; })
    _evaluateAssertions
    _mkFailedAssertionsString
    _mkMissingPackagesAssertions
    ;

  # See ./cuda.nix for documentation.
  inherit (import ./cuda.nix { inherit _cuda lib; })
    _cudaCapabilityIsDefault
    _cudaCapabilityIsSupported
    _mkCudaVariant
    allowUnfreeCudaPredicate
    ;

  # See ./licenses.nix for documentation.
  licenses = import ./licenses.nix;

  # See ./meta.nix for documentation.
  inherit (import ./meta.nix { inherit _cuda lib; })
    _mkMetaBadPlatforms
    _mkMetaBroken
    ;

  # See ./redist.nix for documentation.
  inherit (import ./redist.nix { inherit _cuda lib; })
    _redistSystemIsSupported
    getNixSystems
    getRedistSystem
    mkRedistUrl
    selectManifests
    ;

  # See ./strings.nix for documentation.
  inherit (import ./strings.nix { inherit _cuda lib; })
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
  inherit (import ./versions.nix { inherit _cuda lib; })
    majorMinorPatch
    trimComponents
    ;
}

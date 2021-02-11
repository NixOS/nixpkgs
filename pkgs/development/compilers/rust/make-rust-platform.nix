{ buildPackages, callPackage }:

{ rustc, cargo, ... }:

rec {
  rust = {
    inherit rustc cargo;
  };

  fetchCargoTarball = buildPackages.callPackage ../../../build-support/rust/fetchCargoTarball.nix {
    inherit cargo;
  };

  buildRustPackage = callPackage ../../../build-support/rust {
    inherit rustc cargo cargoSetupHook fetchCargoTarball;
  };

  rustcSrc = callPackage ./rust-src.nix {
    inherit rustc;
  };

  rustLibSrc = callPackage ./rust-lib-src.nix {
    inherit rustc;
  };

  # Hooks
  inherit (callPackage ../../../build-support/rust/hooks { }) cargoSetupHook;
}

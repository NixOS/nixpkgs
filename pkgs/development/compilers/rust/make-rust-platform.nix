{ lib, buildPackages, callPackage, callPackages, cargo-auditable, config, stdenv, runCommand }@prev:

{ rustc
, cargo
, cargo-auditable ? prev.cargo-auditable
, stdenv ? prev.stdenv
, ...
}:

rec {
  fetchCargoTarball = buildPackages.callPackage ../../../build-support/rust/fetch-cargo-tarball {
    git = buildPackages.gitMinimal;
    inherit cargo;
  };

  fetchCargoVendor = buildPackages.callPackage ../../../build-support/rust/fetch-cargo-vendor.nix { inherit cargo; };

  buildRustPackage = callPackage ../../../build-support/rust/build-rust-package {
    inherit stdenv cargoBuildHook cargoCheckHook cargoInstallHook cargoNextestHook cargoSetupHook
      fetchCargoTarball fetchCargoVendor importCargoLock rustc cargo cargo-auditable;
  };

  importCargoLock = buildPackages.callPackage ../../../build-support/rust/import-cargo-lock.nix { inherit cargo; };

  rustcSrc = callPackage ./rust-src.nix {
    inherit runCommand rustc;
  };

  rustLibSrc = callPackage ./rust-lib-src.nix {
    inherit runCommand rustc;
  };

  # Hooks
  inherit (callPackages ../../../build-support/rust/hooks {
    inherit stdenv cargo rustc;
  }) cargoBuildHook cargoCheckHook cargoInstallHook cargoNextestHook cargoSetupHook maturinBuildHook bindgenHook;
} // lib.optionalAttrs config.allowAliases {
  rust = {
    rustc = lib.warn "rustPlatform.rust.rustc is deprecated. Use rustc instead." rustc;
    cargo = lib.warn "rustPlatform.rust.cargo is deprecated. Use cargo instead." cargo;
  };
}

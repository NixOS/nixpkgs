{ lib, buildPackages, callPackage, stdenv, runCommand }@prev:

{ rustc, cargo, stdenv ? prev.stdenv, ... }:

lib.makeExtensible (self: {
  rust = {
    inherit rustc cargo;
  };

  fetchCargoTarball = buildPackages.callPackage ../../../build-support/rust/fetch-cargo-tarball {
    git = buildPackages.gitMinimal;
    inherit (self.rust) cargo;
  };

  buildRustPackage = callPackage ../../../build-support/rust/build-rust-package {
    git = buildPackages.gitMinimal;
    inherit stdenv;
    inherit (self.rust) rustc;
    inherit (self) cargoBuildHook cargoCheckHook cargoInstallHook cargoNextestHook cargoSetupHook
      fetchCargoTarball importCargoLock;
  };

  importCargoLock = buildPackages.callPackage ../../../build-support/rust/import-cargo-lock.nix {
    inherit (self.rust) cargo;
  };

  rustcSrc = callPackage ./rust-src.nix {
    inherit runCommand;
    inherit (self.rust) rustc;
  };

  rustLibSrc = callPackage ./rust-lib-src.nix {
    inherit runCommand;
    inherit (self.rust) rustc;
  };

  # Hooks
  inherit (callPackage ../../../build-support/rust/hooks {
    inherit stdenv;
    inherit (self.rust) cargo rustc;
  }) cargoBuildHook cargoCheckHook cargoInstallHook cargoNextestHook cargoSetupHook maturinBuildHook bindgenHook;
})

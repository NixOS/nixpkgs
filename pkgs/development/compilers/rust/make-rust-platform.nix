{
  lib,
  buildPackages,
  callPackages,
  cargo-auditable,
  config,
  stdenv,
  runCommand,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
}@prev:

{
  rustc,
  cargo,
  cargo-auditable ? prev.cargo-auditable,
  stdenv ? prev.stdenv,
  ...
}:

(makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "rustPlatform";
  f =
    self:
    let
      inherit (self) callPackage;
    in
    {
      fetchCargoVendor = buildPackages.callPackage ../../../build-support/rust/fetch-cargo-vendor.nix {
        inherit cargo;
      };

      buildRustPackage = callPackage ../../../build-support/rust/build-rust-package {
        inherit
          stdenv
          rustc
          cargo
          cargo-auditable
          ;
      };

      importCargoLock = buildPackages.callPackage ../../../build-support/rust/import-cargo-lock.nix {
        inherit cargo;
      };

      rustcSrc = callPackage ./rust-src.nix {
        inherit runCommand rustc;
      };

      rustLibSrc = callPackage ./rust-lib-src.nix {
        inherit runCommand rustc;
      };

      # Useful when rebuilding std
      # e.g. when building wasm with wasm-pack
      rustVendorSrc = callPackage ./rust-vendor-src.nix {
        inherit runCommand rustc;
      };

      # Hooks
      inherit
        (callPackages ../../../build-support/rust/hooks {
          inherit
            stdenv
            ;
        })
        cargoBuildHook
        cargoCheckHook
        cargoInstallHook
        cargoNextestHook
        cargoSetupHook
        maturinBuildHook
        bindgenHook
        ;

      # Let packages reference the build derivations, e.g. for disallowedReferences.
      # Get rid of the splicing though, so `nativeBuildInputs = [ rustPlatform.rust.rustc ]` works.
      rust = {
        rustc = rustc.__spliced.hostTarget or rustc;
        cargo = cargo.__spliced.hostTarget or cargo;
      };
    };
})
// lib.optionalAttrs config.allowAliases {
  # Added in 25.05.
  fetchCargoTarball = throw "`rustPlatform.fetchCargoTarball` has been removed in 25.05, use `rustPlatform.fetchCargoVendor` instead";
}

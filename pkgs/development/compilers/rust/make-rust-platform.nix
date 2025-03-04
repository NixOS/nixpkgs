{
  lib,
  cargo-auditable,
  config,
  makeScopeWithSplicing',
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgsBuildTarget,
  pkgsHostHost,
  pkgsHostTarget,
  pkgsTargetTarget,
}@prev:

{
  rustc,
  cargo,
  cargo-auditable ? prev.cargo-auditable,
  ...
}:

let
  f =
    self:
    let
      inherit (self) callPackage;
      callPackages = callPackage ({ callPackages }: callPackages) { };
      stdenv = callPackage ({ stdenv }: stdenv) { };
      targetStdenv = callPackage ({ pkgsTargetTarget }: pkgsTargetTarget.stdenv) { };
    in
    {
      fetchCargoTarball = callPackage (
        { buildPackages }:
        buildPackages.callPackage ../../../build-support/rust/fetch-cargo-tarball {
          inherit stdenv cargo;
        }
      ) { };

      fetchCargoVendor = callPackage (
        { buildPackages }:
        buildPackages.callPackage ../../../build-support/rust/fetch-cargo-vendor.nix {
          inherit cargo;
        }
      ) { };

      buildRustPackage = callPackage ../../../build-support/rust/build-rust-package {
        inherit
          stdenv
          rustc
          cargo
          cargo-auditable
          ;
      };

      importCargoLock = callPackage (
        { buildPackages }:
        buildPackages.callPackage ../../../build-support/rust/import-cargo-lock.nix {
          inherit cargo;
        }
      ) { };

      rustcSrc = callPackage ./rust-src.nix {
        inherit rustc;
      };

      rustLibSrc = callPackage ./rust-lib-src.nix {
        inherit rustc;
      };

      # Hooks
      inherit
        (callPackages ../../../build-support/rust/hooks {
          inherit
            stdenv
            cargo
            rustc
            callPackage
            targetStdenv
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
    };
in
(makeScopeWithSplicing' {
  otherSplices = {
    selfBuildBuild = lib.makeScope pkgsBuildBuild.newScope f;
    selfBuildHost = lib.makeScope pkgsBuildHost.newScope f;
    selfBuildTarget = lib.makeScope pkgsBuildTarget.newScope f;
    selfHostHost = lib.makeScope pkgsHostHost.newScope f;
    selfHostTarget = lib.makeScope pkgsHostTarget.newScope f;
    selfTargetTarget = lib.optionalAttrs (pkgsTargetTarget ? newScope) (
      lib.makeScope pkgsTargetTarget.newScope f
    );
  };
  inherit f;
})
// lib.optionalAttrs config.allowAliases {
  rust = {
    rustc = lib.warn "rustPlatform.rust.rustc is deprecated. Use rustc instead." rustc;
    cargo = lib.warn "rustPlatform.rust.cargo is deprecated. Use cargo instead." cargo;
  };
}

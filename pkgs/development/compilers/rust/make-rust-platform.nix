{ lib, buildPackages, callPackage, cargo-auditable, stdenv, runCommand }@prev:

{ rustc
, cargo
, cargo-auditable ? prev.cargo-auditable
, stdenv ? prev.stdenv
, ...
}:

let
  fetchCargoTarball = buildPackages.callPackage ../../../build-support/rust/fetch-cargo-tarball {
    git = buildPackages.gitMinimal;
    inherit cargo;
  };

  # Derivations built with `buildRustPackage` can already be overridden with
  # `override`, `overrideAttrs`, and `overrideDerivation`.
  # This function introduces `overrideRust` and it overrides the call to
  # `buildRustPackage`.
  makeOverridableRustPackage = f:
    let
      # Creates a functor with the same arguments as f
      mirrorArgs = lib.mirrorFunctionArgs f;
      transform = origArgs:
      let
        result = f origArgs;

        overrideWith =
          newArgs: origArgs // (
            if lib.isFunction newArgs
            then newArgs origArgs
            else newArgs);

        overrideRust = mirrorArgs (newArgs: makeOverridableRustPackage f (overrideWith newArgs));

        # Change the result of the function call by applying g to it
        overrideResult = g: makeOverridableRustPackage (mirrorArgs (newArgs: g (f newArgs))) origArgs;
      in
        if builtins.isAttrs result
        then result // {
          inherit overrideRust;
        } // (lib.optionalAttrs (result ? override) {
          override = newArgs: overrideResult (x: x.override newArgs);
        })
        else if builtins.isFunction result
        # Note: `lib.mirrorFunctionArgs` transforms `result` into a functor
        # while propagating its arguments.
        then lib.mirrorFunctionArgs result result // {
          inherit overrideRust;
        }
        else result;
    in if builtins.isAttrs f
       then f // (mirrorArgs transform)
       else mirrorArgs transform;

  buildRustPackageImpl = callPackage ../../../build-support/rust/build-rust-package {
    inherit stdenv cargoBuildHook cargoCheckHook cargoInstallHook cargoNextestHook cargoSetupHook
      fetchCargoTarball importCargoLock rustc cargo cargo-auditable;
  };

  buildRustPackage = makeOverridableRustPackage buildRustPackageImpl;

  importCargoLock = buildPackages.callPackage ../../../build-support/rust/import-cargo-lock.nix { inherit cargo; };

  rustcSrc = callPackage ./rust-src.nix {
    inherit runCommand rustc;
  };

  rustLibSrc = callPackage ./rust-lib-src.nix {
    inherit runCommand rustc;
  };

  # Hooks
  inherit (callPackage ../../../build-support/rust/hooks {
    inherit stdenv cargo rustc;
  }) cargoBuildHook cargoCheckHook cargoInstallHook cargoNextestHook cargoSetupHook maturinBuildHook bindgenHook;

in {
  rust = {
    rustc = lib.warn "rustPlatform.rust.rustc is deprecated. Use rustc instead." rustc;
    cargo = lib.warn "rustPlatform.rust.cargo is deprecated. Use cargo instead." cargo;
  };

  inherit fetchCargoTarball buildRustPackage importCargoLock rustcSrc rustLibSrc;

  # Hooks
  inherit cargoBuildHook cargoCheckHook cargoInstallHook cargoNextestHook cargoSetupHook maturinBuildHook bindgenHook;
}

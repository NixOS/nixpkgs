{ rustcVersion
, rustcSha256
, enableRustcDev ? true
, bootstrapVersion
, bootstrapHashes
, selectRustPackage
, rustcPatches ? []
, llvmShared
, llvmSharedForBuild
, llvmSharedForHost
, llvmSharedForTarget
, llvmPackages # Exposed through rustc for LTO in Firefox
}:
{ stdenv, lib
, buildPackages
, targetPackages
, newScope, callPackage
, CoreFoundation, Security, SystemConfiguration
, pkgsBuildBuild
, makeRustPlatform
, wrapRustcWith
}:

let
  # Use `import` to make sure no packages sneak in here.
  lib' = import ../../../build-support/rust/lib { inherit lib stdenv buildPackages targetPackages; };
  # Allow faster cross compiler generation by reusing Build artifacts
  fastCross = (stdenv.buildPlatform == stdenv.hostPlatform) && (stdenv.hostPlatform != stdenv.targetPlatform);
in
{
  lib = lib';

  # Backwards compat before `lib` was factored out.
  inherit (lib') toTargetArch toTargetOs toRustTarget toRustTargetSpec IsNoStdTarget toRustTargetForUseInEnvVars envVars;

  # This just contains tools for now. But it would conceivably contain
  # libraries too, say if we picked some default/recommended versions to build
  # by Hydra.
  #
  # In the end game, rustc, the rust standard library (`core`, `std`, etc.),
  # and cargo would themselves be built with `buildRustCreate` like
  # everything else. Tools and `build.rs` and procedural macro dependencies
  # would be taken from `buildRustPackages` (and `bootstrapRustPackages` for
  # anything provided prebuilt or their build-time dependencies to break
  # cycles / purify builds). In this way, nixpkgs would be in control of all
  # bootstrapping.
  packages = {
    prebuilt = callPackage ./bootstrap.nix {
      version = bootstrapVersion;
      hashes = bootstrapHashes;
    };
    stable = lib.makeScope newScope (self: let
      # Like `buildRustPackages`, but may also contain prebuilt binaries to
      # break cycle. Just like `bootstrapTools` for nixpkgs as a whole,
      # nothing in the final package set should refer to this.
      bootstrapRustPackages = if fastCross
      then pkgsBuildBuild.rustPackages
      else
        self.buildRustPackages.overrideScope (_: _:
        lib.optionalAttrs (stdenv.buildPlatform == stdenv.hostPlatform)
          (selectRustPackage buildPackages).packages.prebuilt);
      bootRustPlatform = makeRustPlatform bootstrapRustPackages;
    in {
      # Packages suitable for build-time, e.g. `build.rs`-type stuff.
      buildRustPackages = (selectRustPackage buildPackages).packages.stable // { __attrsFailEvaluation = true; };
      # Analogous to stdenv
      rustPlatform = makeRustPlatform self.buildRustPackages;
      rustc-unwrapped = self.callPackage ./rustc.nix ({
        version = rustcVersion;
        sha256 = rustcSha256;
        inherit enableRustcDev;
        inherit llvmShared llvmSharedForBuild llvmSharedForHost llvmSharedForTarget llvmPackages fastCross;

        patches = rustcPatches;

        # Use boot package set to break cycle
        inherit (bootstrapRustPackages) cargo rustc rustfmt;
      });
      rustc = wrapRustcWith {
        inherit (self) rustc-unwrapped;
        sysroot = if fastCross then self.rustc-unwrapped else null;
      };
      rustfmt = self.callPackage ./rustfmt.nix {
        inherit Security;
        inherit (self.buildRustPackages) rustc;
      };
      cargo = if (!fastCross) then self.callPackage ./cargo.nix {
        # Use boot package set to break cycle
        rustPlatform = bootRustPlatform;
        inherit CoreFoundation Security;
      } else self.callPackage ./cargo_cross.nix {};
      cargo-auditable = self.callPackage ./cargo-auditable.nix { };
      cargo-auditable-cargo-wrapper = self.callPackage ./cargo-auditable-cargo-wrapper.nix { };
      clippy = self.callPackage ./clippy.nix {
        # We want to use self, not buildRustPackages, so that
        # buildPackages.clippy uses the cross compiler and supports
        # linting for the target platform.
        rustPlatform = makeRustPlatform self;
        inherit Security;
      };
    });
  };
}

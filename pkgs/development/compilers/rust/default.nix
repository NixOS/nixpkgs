{
  rustcVersion,
  rustcSha256,
  enableRustcDev ? true,
  # Build a reduced compiler (host target only, no docs/rustc-dev). Set for the
  # intermediate links of the mrustc source-bootstrap chain.
  minimal ? false,
  bootstrapVersion,
  bootstrapHashes,
  selectRustPackage,
  rustcPatches ? [ ],
  # When non-null, bootstrap this rustc from the given { rustc; cargo; } set (the
  # previous link in the mrustc source chain) instead of the prebuilt binary
  # download in `packages.prebuilt`. Only `rustc` and `cargo` are required.
  bootstrapPackagesOverride ? null,
  # When non-null, forces cargo's `auditable` flag (the mrustc chain sets it
  # false). null keeps cargo.nix's default. Avoids pulling the binary-bootstrapped
  # cargo-auditable into the source-chain closure.
  cargoAuditable ? null,
  llvmShared,
  llvmSharedForBuild,
  llvmSharedForHost,
  llvmSharedForTarget,
  llvmPackages, # Exposed through rustc for LTO in Firefox
  cargo-auditable,
}:
{
  stdenv,
  lib,
  newScope,
  callPackage,
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgsBuildTarget,
  pkgsTargetTarget,
  makeRustPlatform,
  wrapRustcWith,
}:

let
  # Use `import` to make sure no packages sneak in here.
  lib' = import ../../../build-support/rust/lib {
    inherit
      lib
      stdenv
      pkgsBuildHost
      pkgsBuildTarget
      pkgsTargetTarget
      ;
  };
  # Allow faster cross compiler generation by reusing Build artifacts
  fastCross =
    (stdenv.buildPlatform == stdenv.hostPlatform) && (stdenv.hostPlatform != stdenv.targetPlatform);
in
{
  lib = lib';

  # Backwards compat before `lib` was factored out.
  inherit (lib')
    toTargetArch
    toTargetOs
    toRustTarget
    toRustTargetSpec
    IsNoStdTarget
    toRustTargetForUseInEnvVars
    envVars
    ;

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
    stable = lib.makeScope newScope (
      self:
      let
        # Like `buildRustPackages`, but may also contain prebuilt binaries to
        # break cycle. Just like `bootstrapTools` for nixpkgs as a whole,
        # nothing in the final package set should refer to this.
        bootstrapRustPackages =
          if fastCross then
            pkgsBuildBuild.rustPackages
          else if bootstrapPackagesOverride != null then
            # Source-bootstrap chain link: bootstrap from the previous link's
            # compiler (or, for the base link, an mrustc-built rustc+cargo)
            # instead of the prebuilt binary download.
            self.buildRustPackages.overrideScope (
              _: _: lib.optionalAttrs (stdenv.buildPlatform == stdenv.hostPlatform) bootstrapPackagesOverride
            )
          else
            self.buildRustPackages.overrideScope (
              _: _:
              lib.optionalAttrs (stdenv.buildPlatform == stdenv.hostPlatform)
                (selectRustPackage pkgsBuildHost).packages.prebuilt
            );
        bootRustPlatform = makeRustPlatform bootstrapRustPackages;
      in
      {
        # Packages suitable for build-time, e.g. `build.rs`-type stuff.
        buildRustPackages = (selectRustPackage pkgsBuildHost).packages.stable;
        # Analogous to stdenv
        rustPlatform = makeRustPlatform self.buildRustPackages;
        rustc-unwrapped = self.callPackage ./rustc.nix {
          version = rustcVersion;
          sha256 = rustcSha256;
          inherit enableRustcDev minimal;
          inherit
            llvmShared
            llvmSharedForBuild
            llvmSharedForHost
            llvmSharedForTarget
            llvmPackages
            fastCross
            ;

          patches = rustcPatches;

          # Use boot package set to break cycle
          inherit (bootstrapRustPackages) cargo rustc rustfmt;
        };
        rustc = wrapRustcWith {
          inherit (self) rustc-unwrapped;
          sysroot = if fastCross then self.rustc-unwrapped else null;
        };
        rustfmt = self.callPackage ./rustfmt.nix {
          inherit (self.buildRustPackages) rustc;
        };
        cargo =
          if (!fastCross) then
            self.callPackage ./cargo.nix (
              {
                # Use boot package set to break cycle
                rustPlatform = bootRustPlatform;
              }
              # The default cargo-auditable is built with the binary-bootstrapped
              # rustc; the mrustc source chain disables auditable to keep its
              # closure free of any prebuilt rust binary. `null` keeps cargo.nix's
              # own default (auditable iff cargo-auditable is not broken).
              // lib.optionalAttrs (cargoAuditable != null) { auditable = cargoAuditable; }
            )
          else
            self.callPackage ./cargo_cross.nix { };
        inherit cargo-auditable;
        cargo-auditable-cargo-wrapper = self.callPackage ./cargo-auditable-cargo-wrapper.nix { };
        clippy-unwrapped = self.callPackage ./clippy.nix { };
        clippy = if !fastCross then self.clippy-unwrapped else self.callPackage ./clippy-wrapper.nix { };
      }
    );
  };
}

{
  rustcVersion,
  rustcSha256,
  enableRustcDev ? true,
  bootstrapVersion,
  bootstrapHashes,
  selectRustPackage,
  rustcPatches ? [ ],
  llvmShared,
  llvmSharedForBuild,
  llvmSharedForHost,
  llvmSharedForTarget,
  llvmPackages, # Exposed through rustc for LTO in Firefox
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
        buildRustPackages = (selectRustPackage pkgsBuildHost).packages.stable // {
          # Prevent `pkgs/top-level/release-attrpaths-superset.nix` from recursing more than one level here.
          buildRustPackages = self.buildRustPackages // {
            __attrsFailEvaluation = true;
          };
        };
        # Analogous to stdenv
        rustPlatform = makeRustPlatform self.buildRustPackages;
        rustc-unwrapped =
          # Rust’s build system identifies platforms by triple, and
          # therefore can’t handle the case where the build, host, or
          # target platform have the same triple but different
          # configurations (e.g., linker).
          #
          # This results in build failures when attempting to compile
          # a dynamic‐to‐static Rust compiler on platforms that Nixpkgs
          # is strict about static separation with (currently only
          # Darwin), as it tries to link dynamic executables for the
          # build platform using the static linker.
          #
          # Since the built `std` should be the same regardless of
          # static vs. dynamic, and since Rust apparently does not
          # remember the specified target configuration in the built
          # compiler anyway (hence our need to teach it about the
          # linker and so on again in wrappers and hooks), we work
          # around the problem in this one specific case by reusing the
          # `pkgsBuildBuild` compiler, which also conveniently saves
          # a Rust build.
          #
          # This does assume that `pkgsBuildBuild.rustPackages` matches
          # the compiler version, LLVM version, patches, etc., and may
          # interact poorly in the face of overrides. It might possible
          # to do this in a better way, but this beats not having a
          # working compiler at all.
          #
          # The longer‐term fix would be to get Rust to use a more
          # nuanced understanding of platforms, such as by explicitly
          # constructing and passing Rust JSON target definitions that
          # let us distinguish the platforms in cases like these. That
          # would also let us supplant various hacks around the
          # wrappers and hooks that we currently need.
          if
            fastCross
            && stdenv.targetPlatform.rust.rustcTarget == stdenv.buildPlatform.rust.rustcTarget
            && stdenv.targetPlatform.isStatic != stdenv.buildPlatform.isStatic
          then
            pkgsBuildBuild.rustPackages.rustc-unwrapped
          else
            callPackage ./rustc.nix ({
              version = rustcVersion;
              sha256 = rustcSha256;
              inherit enableRustcDev;
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
            });
        rustc = wrapRustcWith {
          inherit (self) rustc-unwrapped;
          sysroot = if fastCross then self.rustc-unwrapped else null;
        };
        rustfmt = self.callPackage ./rustfmt.nix {
          inherit (self.buildRustPackages) rustc;
        };
        cargo =
          if (!fastCross) then
            self.callPackage ./cargo.nix {
              # Use boot package set to break cycle
              rustPlatform = bootRustPlatform;
            }
          else
            self.callPackage ./cargo_cross.nix { };
        cargo-auditable = self.callPackage ./cargo-auditable.nix { };
        cargo-auditable-cargo-wrapper = self.callPackage ./cargo-auditable-cargo-wrapper.nix { };
        clippy = self.callPackage ./clippy.nix {
          # We want to use self, not buildRustPackages, so that
          # buildPackages.clippy uses the cross compiler and supports
          # linting for the target platform.
          rustPlatform = makeRustPlatform self;
        };
      }
    );
  };
}

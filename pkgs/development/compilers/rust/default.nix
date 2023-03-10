{ rustcVersion
, rustcSha256
, enableRustcDev ? true
, bootstrapVersion
, bootstrapHashes
, selectRustPackage
, rustcPatches ? []
, llvmBootstrapForDarwin
, llvmShared
, llvmSharedForBuild
, llvmSharedForHost
, llvmSharedForTarget
, llvmPackages # Exposed through rustc for LTO in Firefox
}:
{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security, SystemConfiguration
, pkgsBuildTarget, pkgsBuildBuild
, makeRustPlatform
}:

let
  # Use `import` to make sure no packages sneak in here.
  lib' = import ../../../build-support/rust/lib { inherit lib; };
in
{
  lib = lib';

  # Backwards compat before `lib` was factored out.
  inherit (lib') toTargetArch toTargetOs toRustTarget toRustTargetSpec IsNoStdTarget;

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
      bootstrapRustPackages = self.buildRustPackages.overrideScope' (_: _:
        lib.optionalAttrs (stdenv.buildPlatform == stdenv.hostPlatform)
          (selectRustPackage buildPackages).packages.prebuilt);
      bootRustPlatform = makeRustPlatform bootstrapRustPackages;
    in {
      # Packages suitable for build-time, e.g. `build.rs`-type stuff.
      buildRustPackages = (selectRustPackage buildPackages).packages.stable;
      # Analogous to stdenv
      rustPlatform = makeRustPlatform self.buildRustPackages;
      rustc = self.callPackage ./rustc.nix ({
        version = rustcVersion;
        sha256 = rustcSha256;
        inherit enableRustcDev;
        inherit llvmShared llvmSharedForBuild llvmSharedForHost llvmSharedForTarget llvmPackages;

        patches = rustcPatches;

        # Use boot package set to break cycle
        rustPlatform = bootRustPlatform;
      } // lib.optionalAttrs (stdenv.cc.isClang && stdenv.hostPlatform == stdenv.buildPlatform) {
        stdenv = llvmBootstrapForDarwin.stdenv;
        pkgsBuildBuild = pkgsBuildBuild // { targetPackages.stdenv = llvmBootstrapForDarwin.stdenv; };
        pkgsBuildHost = pkgsBuildBuild // { targetPackages.stdenv = llvmBootstrapForDarwin.stdenv; };
        pkgsBuildTarget = pkgsBuildTarget // { targetPackages.stdenv = llvmBootstrapForDarwin.stdenv; };
      });
      rustfmt = self.callPackage ./rustfmt.nix { inherit Security; };
      cargo = self.callPackage ./cargo.nix {
        # Use boot package set to break cycle
        rustPlatform = bootRustPlatform;
        inherit CoreFoundation Security;
      };
      cargo-auditable = self.callPackage ./cargo-auditable.nix { };
      cargo-auditable-cargo-wrapper = self.callPackage ./cargo-auditable-cargo-wrapper.nix { };
      clippy = self.callPackage ./clippy.nix { inherit Security; };
    });
  };
}

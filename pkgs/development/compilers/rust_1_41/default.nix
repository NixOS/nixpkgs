{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, llvmPackages_8
, pkgsBuildTarget, pkgsBuildBuild
}: rec {
  makeRustPlatform = { rustc, cargo, ... }: {
    rust = {
      inherit rustc cargo;
    };

    buildRustPackage = callPackage ../../../build-support/rust {
      inherit rustc cargo;

      fetchcargo = buildPackages.callPackage ../../../build-support/rust/fetchcargo.nix {
        inherit cargo;
      };
    };

    rustcSrc = callPackage ./rust-src.nix {
      inherit rustc;
    };
  };

  # This just contains tools for now. But it would conceivably contain
  # libraries too, say if we picked some default/recommended versions from
  # `cratesIO` to build by Hydra and/or try to prefer/bias in Cargo.lock for
  # all vendored Carnix-generated nix.
  #
  # In the end game, rustc, the rust standard library (`core`, `std`, etc.),
  # and cargo would themselves be built with `buildRustCreate` like
  # everything else. Tools and `build.rs` and procedural macro dependencies
  # would be taken from `buildRustPackages` (and `bootstrapRustPackages` for
  # anything provided prebuilt or their build-time dependencies to break
  # cycles / purify builds). In this way, nixpkgs would be in control of all
  # bootstrapping.
  packages = {
    prebuilt = callPackage ./bootstrap.nix {};
    stable = lib.makeScope newScope (self: let
      # Like `buildRustPackages`, but may also contain prebuilt binaries to
      # break cycle. Just like `bootstrapTools` for nixpkgs as a whole,
      # nothing in the final package set should refer to this.
      bootstrapRustPackages = self.buildRustPackages.overrideScope' (_: _:
        lib.optionalAttrs (stdenv.buildPlatform == stdenv.hostPlatform)
          buildPackages.rust_1_41.packages.prebuilt);
      bootRustPlatform = makeRustPlatform bootstrapRustPackages;
    in {
      # Packages suitable for build-time, e.g. `build.rs`-type stuff.
      buildRustPackages = buildPackages.rust_1_41.packages.stable;
      # Analogous to stdenv
      rustPlatform = makeRustPlatform self.buildRustPackages;
      rustc = self.callPackage ./rustc.nix ({
        # Use boot package set to break cycle
        rustPlatform = bootRustPlatform;
      } // lib.optionalAttrs (stdenv.cc.isClang && stdenv.hostPlatform == stdenv.buildPlatform) {
        stdenv = llvmPackages_8.stdenv;
        pkgsBuildBuild = pkgsBuildBuild // { targetPackages.stdenv = llvmPackages_8.stdenv; };
        pkgsBuildHost = pkgsBuildBuild // { targetPackages.stdenv = llvmPackages_8.stdenv; };
        pkgsBuildTarget = pkgsBuildTarget // { targetPackages.stdenv = llvmPackages_8.stdenv; };
      });
      rustfmt = self.callPackage ./rustfmt.nix { inherit Security; };
      cargo = self.callPackage ./cargo.nix {
        # Use boot package set to break cycle
        rustPlatform = bootRustPlatform;
        inherit CoreFoundation Security;
      };
      clippy = self.callPackage ./clippy.nix { inherit Security; };
      rls = self.callPackage ./rls { inherit CoreFoundation Security; };
    });
  };
}

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
}:
{ stdenv, lib
, buildPackages
, newScope, callPackage
, CoreFoundation, Security
, pkgsBuildTarget, pkgsBuildBuild
, makeRustPlatform
}: rec {
  # https://doc.rust-lang.org/reference/conditional-compilation.html#target_arch
  toTargetArch = platform:
    if platform.isAarch32 then "arm"
    else platform.parsed.cpu.name;

  # https://doc.rust-lang.org/reference/conditional-compilation.html#target_os
  toTargetOs = platform:
    if platform.isDarwin then "macos"
    else platform.parsed.kernel.name;

  # Returns the name of the rust target, even if it is custom. Adjustments are
  # because rust has slightly different naming conventions than we do.
  toRustTarget = platform: with platform.parsed; let
    cpu_ = platform.rustc.platform.arch or {
      "armv7a" = "armv7";
      "armv7l" = "armv7";
      "armv6l" = "arm";
    }.${cpu.name} or cpu.name;
  in platform.rustc.config
    or "${cpu_}-${vendor.name}-${kernel.name}${lib.optionalString (abi.name != "unknown") "-${abi.name}"}";

  # Returns the name of the rust target if it is standard, or the json file
  # containing the custom target spec.
  toRustTargetSpec = platform:
    if (platform.rustc or {}) ? platform
    then builtins.toFile (toRustTarget platform + ".json") (builtins.toJSON platform.rustc.platform)
    else toRustTarget platform;

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
        inherit llvmShared llvmSharedForBuild llvmSharedForHost llvmSharedForTarget;

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
      clippy = self.callPackage ./clippy.nix { inherit Security; };
      rls = self.callPackage ./rls { inherit CoreFoundation Security; };
    });
  };
}

{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
in
rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "1.15";
    isRelease = true;
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=stable" ];
    srcRev = "10893a9a349cdd423f2490a6984acb5b3b7c8046";
    srcSha = "0861iivb98ir9ixq2qzznfc1b2l9khlwdln5n0gf2mp1fi3w4d4f";

    patches = [
      ./patches/darwin-disable-fragile-tcp-tests.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;

    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.16.0";
    srcRev = "6e0c18cccc8b0c06fba8a8d76486f81a792fb420";
    srcSha = "117ivvs9wz848mwf8bw797n10qpn77agd353z8b0hxgbxhpribya";
    depsSha256 = "11s2xpgfhl4mb4wa2nk4mzsypr7m9daxxc7l0vraiz5cr77gk7qq";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

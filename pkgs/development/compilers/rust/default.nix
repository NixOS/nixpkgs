{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
in
rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "1.15.1";
    isRelease = true;
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=stable" ];
    srcRev = "021bd294c039bd54aa5c4aa85bcdffb0d24bc892";
    srcSha = "1dp7cjxj8nv960jxkq3p18agh9bpfb69ac14x284jmhwyksim3y7";

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

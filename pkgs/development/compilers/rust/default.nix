{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
in
rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "1.14";
    isRelease = true;
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=stable" ];
    srcRev = "e8a0123241f0d397d39cd18fcc4e5e7edde22730";
    srcSha = "1sla3gnx9dqvivnyhvwz299mc3jmdy805q2y5xpmpi1vhfk0bafx";

    patches = [
      ./patches/disable-lockfile-check-stable.patch
      ./patches/darwin-disable-fragile-tcp-tests.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;

    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.15.0";
    srcRev = "298a0127f703d4c2500bb06d309488b92ef84ae1";
    srcSha = "0v74r18vszapw2rfk7w72czkp9gbq4s1sggphm5vx0kyh058dxc5";
    depsSha256 = "0ksiywli8r4lkprfknm0yz1w27060psi3db6wblqmi8sckzdm44h";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

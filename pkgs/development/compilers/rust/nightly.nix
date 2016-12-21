{ stdenv, callPackage, rustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "nightly-2016-11-23";
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=nightly" ];
    srcRev = "d5814b03e652043be607f96e24709e06c2b55429";
    srcSha = "0x2vr1mda0mr8q28h96zfpv0f26dyrg8jwxznlh6gk0y0mprgcbr";
    patches = [
     ./patches/disable-lockfile-check-nightly.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "nightly-2016-07-25";
    srcRev = "f09ef68cc47956ccc5f99212bdcdd15298c400a0";
    srcSha = "1r6q9jd0fl6mzhwkvrrcv358q2784hg51dfpy28xgh4n61m7c155";
    depsSha256 = "055ky0lkrcsi976kmvc4lqyv0sjdpcj3jv36kz9hkqq0gip3crjc";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

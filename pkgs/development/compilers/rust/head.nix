{ stdenv, callPackage, rustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "master-1.13.0";
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=nightly" ];
    srcRev = "308824acecf902f2b6a9c1538bde0324804ba68e";
    srcSha = "17zv1a27a7w6n3a22brriqx5m6i4s3nsj7mlnpliwghlbz8q7384";
    patches = [
      ./patches/disable-lockfile-check.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "master-2016-07-25";
    srcRev = "f09ef68cc47956ccc5f99212bdcdd15298c400a0";
    srcSha = "1r6q9jd0fl6mzhwkvrrcv358q2784hg51dfpy28xgh4n61m7c155";
    depsSha256 = "1p1ygabg9k9b0azm0mrx8asjzdi35c5zw53iysba198lli6bhdl4";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

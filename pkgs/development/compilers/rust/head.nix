{ stdenv, callPackage, rustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "master-1.12.0";
    forceBundledLLVM = false;
    needsCmake = true;
    configureFlags = [ "--release-channel=nightly" ];
    srcRev = "d9a911d236cbecb47775276ba51a5f9111bdbc9c";
    srcSha = "07wybqvnw99fljmcy33vb9iwirmp10cwy47n008p396s7pb852hv";
    patches = [
      ./patches/disable-lockfile-check.patch
      # Drop this patch after
      # https://github.com/rust-lang/rust/pull/35140 gets merged
      ./patches/tcp-stress-test-run-a-smaller-number-of-threads.patch
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

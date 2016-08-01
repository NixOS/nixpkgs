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
    version = "master-0.13.0";
    srcRev = "fb2faf29b26da39bd815b470ca73255dbfe30e42";
    srcSha = "1r7wd3hp85mvmm7ivj01k65qcgb6qk1mys9mp48ww9k5cdniwcaj";
    depsSha256 = "0lsf99pgl6wnl1lfk0drp5l4agrx7hzgdbps7hy3rprbf41jd6ai";
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

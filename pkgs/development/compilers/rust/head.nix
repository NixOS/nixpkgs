{ stdenv, callPackage, rustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "master-1.12.0";
    forceBundledLLVM = false;
    needsCmake = true;
    srcRev = "c77f8ce7c3284441a00faed6782d08eb5a78296c";
    srcSha = "11y24bm2rj7bzsf86iyx3v286ygxprch4c804qbl1w477mkhcac7";
    patches = [
      ./patches/disable-lockfile-check.patch
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

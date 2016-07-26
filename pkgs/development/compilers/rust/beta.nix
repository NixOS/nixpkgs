{ stdenv, callPackage, rustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "beta-1.11.0";
    forceBundledLLVM = false;
    needsCmake = true;
    configureFlags = [ "--release-channel=beta" ];
    srcRev = "9333c420da0da6291740c313d5af3d620b55b8bc";
    srcSha = "05z6i4s5jjw3c5ypap6kzxk81bg4dib47h51znvsvcvr0svsnkgs";
    patches = [
      ./patches/disable-lockfile-check.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "beta-0.13.0";
    srcRev = "fb2faf29b26da39bd815b470ca73255dbfe30e42";
    srcSha = "1r7wd3hp85mvmm7ivj01k65qcgb6qk1mys9mp48ww9k5cdniwcaj";
    depsSha256 = "0lsf99pgl6wnl1lfk0drp5l4agrx7hzgdbps7hy3rprbf41jd6ai";
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

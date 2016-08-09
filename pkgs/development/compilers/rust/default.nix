{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
in

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "1.10.0";
    isRelease = true;
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=stable" ];
    srcRev = "cfcb716cf0961a7e3a4eceac828d94805cf8140b";
    srcSha = "15i81ybh32xymmkyz3bkb5bdgi9hx8nb0sh00ac6qba6w8ljpii9";
    patches = [
      ./patches/disable-lockfile-check.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.11.0";
    srcRev = "refs/tags/${version}";
    srcSha = "0ic2093bmwiw6vl2l9yhip87ni6dbz7dhrizy9wdx61229k16hc4";
    depsSha256 = "0690sgn6fcay7sazlmrbbn4jbhnvmznrpz5z3rvkbaifkjrg4w6d";
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

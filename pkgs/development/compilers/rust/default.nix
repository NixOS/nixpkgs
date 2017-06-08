{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform, llvm
, targets ? []
, targetToolchains ? []
, targetPatches ? []
}:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
in
rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "1.16.0";
    isRelease = true;
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=stable" ];
    srcRev = "30cf806ef8881c41821fbd43e5cf3699c5290c16";
    srcSha = "184qd2mfjpf68jqgc8hjqg62yyy01haf7ircz9xahjnywz7d4paq";

    patches = [
      ./patches/darwin-disable-fragile-tcp-tests.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;

    inherit llvm;
    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.17.0";
    srcRev = "f9e54817e53c7b9845cc7c1ede4c11e4d3e42e36";
    srcSha = "0mvrd9xjv36hmfhmnvv0752qg218x6dxr02w3y2zi27b1kmav2c3";
    depsSha256 = "12a7pbi0ixzycv6k7591b2aqp0wrczq87n8qcvdiipbw2llp2h9z";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

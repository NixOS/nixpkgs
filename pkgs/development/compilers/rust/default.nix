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
    # TODO: We're temporarily tracking master here as Darwin needs the
    # `http.cainfo` option from .cargo/config which isn't released
    # yet.

    version = "master-2016-07-25";
    srcRev = "f09ef68cc47956ccc5f99212bdcdd15298c400a0";
    srcSha = "1r6q9jd0fl6mzhwkvrrcv358q2784hg51dfpy28xgh4n61m7c155";
    depsSha256 = "1p1ygabg9k9b0azm0mrx8asjzdi35c5zw53iysba198lli6bhdl4";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

{ stdenv, callPackage, rustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "beta-2016-08-17";
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=beta" ];
    srcRev = "822166b842e4d0b32fafc8b077fb927ec281253d";
    srcSha = "1zkv7hyjvcj7kvbngf309skgllk6rd7727a6hkvhd3hg8jlz0d00";
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

    version = "beta-2016-07-25";
    srcRev = "f09ef68cc47956ccc5f99212bdcdd15298c400a0";
    srcSha = "1r6q9jd0fl6mzhwkvrrcv358q2784hg51dfpy28xgh4n61m7c155";
    depsSha256 = "055ky0lkrcsi976kmvc4lqyv0sjdpcj3jv36kz9hkqq0gip3crjc";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

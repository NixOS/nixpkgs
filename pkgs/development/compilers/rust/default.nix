{ stdenv, callPackage, recurseIntoAttrs, makeRustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

let
  rustPlatform = recurseIntoAttrs (makeRustPlatform (callPackage ./bootstrap.nix {}));
in

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "1.13";
    isRelease = true;
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=stable" ];
    srcRev = "2c6933acc05c61e041be764cb1331f6281993f3f";
    srcSha = "1w0alyyc29cy2lczrqvg1kfycjxy0xg8fpzdac80m88fxpv23glp";

    patches = [
      ./patches/disable-lockfile-check.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;

    inherit targets;
    inherit targetPatches;
    inherit targetToolchains;
    inherit rustPlatform;
  };

  cargo = callPackage ./cargo.nix rec {
    version = "0.14.0";
    srcRev = "eca9e159b6b0d484788ac757cf23052eba75af55";
    srcSha = "1zm5rzw1mvixnkzr4775pcxx6k235qqxbysyp179cbxsw3dm045s";
    depsSha256 = "0gpn0cpwgpzwhc359qn6qplx371ag9pqbwayhqrsydk1zm5bm3zr";

    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

{ stdenv, callPackage, rustPlatform,
  targets ? [], targetToolchains ? [], targetPatches ? [] }:

rec {
  rustc = callPackage ./rustc.nix {
    shortVersion = "beta-2016-11-16";
    forceBundledLLVM = false;
    configureFlags = [ "--release-channel=beta" ];
    srcRev = "e627a2e6edbc7b7fd205de8ca7c86cff76655f4d";
    srcSha = "14sbhn6dp6rri1rpkspjlmy359zicwmyppdak52xj1kqhcjn71wa";
    patches = [
      ./patches/disable-lockfile-check-beta.patch
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

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
    version = "0.12.0";
    srcRev = "6c27aa6985c18d644cbf6a13d54c8ae36aeaae12";
    srcSha = "1piq13aigd0yz0ysff450bfg3z56pw0vzzbzzpcppsnnrnh8zdb2";
    depsSha256 = "1jrwzm9fd15kf2d5zb17q901hx32h711ivcwdpxpmzwq08sjlcvl";
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };
}

{ stdenv, callPackage }:

callPackage ./generic.nix {
  shortVersion = "1.9.0";
  isRelease = true;
  forceBundledLLVM = false;
  configureFlags = [ "--release-channel=stable" ];
  srcRev = "e4e8b666850a763fdf1c3c2c142856ab51e32779";
  srcSha = "1pz4qx70mqv78fxm4w1mq7csk5pssq4qmr2vwwb5v8hyx03caff8";
  patches = [ ./patches/remove-uneeded-git.patch ]
    ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
  rustc = callPackage ./bootstrap.nix {};
}

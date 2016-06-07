{ stdenv, callPackage, targets ? [], targetToolchains ? [] }:

callPackage ./generic.nix {
  shortVersion = "1.9.0";
  isRelease = true;
  forceBundledLLVM = false;
  configureFlags = [ "--release-channel=stable" ];
  srcRev = "e4e8b666850a763fdf1c3c2c142856ab51e32779";
  srcSha = "167rh7hs77grn895h54s7np7f0k7b6i8z4wdfinncg4chy08hxq1";
  patches = [ ./patches/remove-uneeded-git.patch ]
    ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
  rustc = callPackage ./snapshot.nix {};
  inherit targets;
  inherit targetToolchains;
}

{ stdenv, fetchurl, makeWrapper, jre, callPackage }:

let
  dotty-bare = callPackage ./dotty-bare.nix {
    inherit stdenv fetchurl makeWrapper jre;
  };
in

stdenv.mkDerivation {
  pname = "dotty";
  inherit (dotty-bare) version;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${dotty-bare}/bin/scalac $out/bin/scalac
    ln -s ${dotty-bare}/bin/scaladoc $out/bin/scaladoc
    ln -s ${dotty-bare}/bin/scala $out/bin/scala
    ln -s ${dotty-bare}/bin/common $out/bin/common
  '';

  inherit (dotty-bare) meta;
}

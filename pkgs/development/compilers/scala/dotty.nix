{ stdenv, fetchurl, makeWrapper, jre, callPackage }:

let
  dotty-bare = callPackage ./dotty-bare.nix {
    inherit stdenv fetchurl makeWrapper jre;
  };
in

stdenv.mkDerivation {
  name = "dotty-${dotty-bare.version}";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${dotty-bare}/bin/dotc $out/bin/dotc
    ln -s ${dotty-bare}/bin/dotd $out/bin/dotd
    ln -s ${dotty-bare}/bin/dotr $out/bin/dotr
  '';

  inherit (dotty-bare) meta;
}

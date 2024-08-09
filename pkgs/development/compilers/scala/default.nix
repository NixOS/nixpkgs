{ stdenv, fetchurl, makeWrapper, jre, callPackage }:

let
  bare = callPackage ./bare.nix {
    inherit stdenv fetchurl makeWrapper jre;
  };
in

stdenv.mkDerivation {
  pname = "scala";
  inherit (bare) version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${bare}/bin/scalac $out/bin/scalac
    ln -s ${bare}/bin/scaladoc $out/bin/scaladoc
    ln -s ${bare}/bin/scala $out/bin/scala
    ln -s ${bare}/bin/common $out/bin/common

    runHook postInstall
  '';

  inherit (bare) meta;
} // { inherit bare; }

{ stdenv
, lib
, callPackage
, unzip
, emacs
, makeWrapper
, installDesktop ? false
}:
let
  mozart2-unwrapped = callPackage ./unwrapped.nix { };
in
stdenv.mkDerivation {

  nativeBuildInputs = [ makeWrapper unzip ];

  propagatedBuildInputs = [ mozart2-unwrapped emacs ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    install -D opi/emacs/oz $out/bin/oz
  '' + lib.optionalString installDesktop ''
    cp -r distrib/share/ $out/share
  '';

  fixupPhase = ''
    wrapProgram $out/bin/oz --set OZHOME ${mozart2-unwrapped} --set OZEMACS ${emacs}/bin/emacs
  '';

  inherit (mozart2-unwrapped) pname name version src meta;
}

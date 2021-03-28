{ lib, stdenv, makeWrapper, coreutils, gnused, gnugrep, diffutils, nix, git, jq }:

stdenv.mkDerivation {
  name = "common-updater-scripts";

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${./scripts}/* $out/bin

    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${lib.makeBinPath [ coreutils gnused gnugrep nix diffutils git jq ]}
    done
  '';
}

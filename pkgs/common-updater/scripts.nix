{ stdenv, makeWrapper, coreutils, gawk, gnused, diffutils, nix }:

stdenv.mkDerivation {
  name = "common-updater-scripts";

  buildInputs = [ makeWrapper ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp ${./scripts}/* $out/bin

    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils gawk gnused nix diffutils ]}
    done
  '';
}

{ stdenvNoCC, makeWrapper, coreutils, jq, nimble, nix-prefetch-git }:

let
  stdenv = stdenvNoCC;
  runtimePath = stdenv.lib.makeBinPath [ coreutils jq nimble nix-prefetch-git ];
in stdenv.mkDerivation rec {
  name = "nix-generate-from-nimble";

  nativeBuildInputs = [ makeWrapper ];

  src = ./generate.sh;
  dontUnpack = true;

  installPhase = ''
    install -vD ${src} $out/bin/$name;
    wrapProgram $out/bin/$name \
      --prefix PATH : ${runtimePath} \
      --set HOME /homeless-shelter
  '';

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description =
      "Script for generating initial package expressions from Nimble";
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.unix;
  };
}

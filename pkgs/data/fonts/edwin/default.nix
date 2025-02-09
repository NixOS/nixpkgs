{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "edwin";
  version = "0.54";

  src = fetchurl {
    url = "https://github.com/MuseScoreFonts/Edwin/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-F6BzwnrsaELegdo6Bdju1OG+RI9zKnn4tIASR3q6zYk=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    install *.otf $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    description = "A text font for musical scores";
    homepage = "https://github.com/MuseScoreFonts/Edwin";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ moni ];
  };
}

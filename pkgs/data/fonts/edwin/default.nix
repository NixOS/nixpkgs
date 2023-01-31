{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "edwin";
  version = "0.52";

  src = fetchurl {
    url = "https://github.com/MuseScoreFonts/Edwin/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-7yQUiLZupGc+RCZdhyO08JWqhROYqMOZ9wRdGJ6uixU=";
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
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}

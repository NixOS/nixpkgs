{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "ydp-grand";
  version = "unstable-2016-08-04";

  src = fetchurl {
    url = "https://freepats.zenvoid.org/Piano/YDP-GrandPiano/YDP-GrandPiano-SF2-20160804.tar.bz2";
    sha256 = "sha256-0kPcPhgqYN8qFukoKMGCHPPrV0i0Xi4r3Pqc968FYCY=";
  };

  installPhase = ''
    install -Dm644 YDP-GrandPiano-*.sf2 $out/share/soundfonts/YDP-GrandPiano.sf2
  '';

  meta = with lib; {
    description = "Acoustic grand piano soundfont";
    homepage = "https://freepats.zenvoid.org/Piano/acoustic-grand-piano.html";
    license = licenses.cc-by-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ ckie ];
  };
}

{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "galatia-sil";
  version = "2.1";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/galatia/GalatiaSIL-${version}.zip";
    hash = "sha256-7kXnTC5vpUOjcT40oNW6e32zFGejlWJq1J+p+5DiAos=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 $downloadedFile *.ttf -t $out/share/fonts/truetype
    install -Dm644 $downloadedFile OFL.txt OFL-FAQ.txt FONTLOG.txt -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://software.sil.org/galatia";
    description = "Font designed to support Biblical Polytonic Greek";
    longDescription = ''
      Galatia SIL, designed to support Biblical Polytonic Greek, is a Unicode 3.1 font released under the SIL Open Font License. The font supports precomposed characters rather than decomposed characters. Thus, you must use a keyboard that outputs NFC encoding (precomposed).
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.kmein ];
  };
}

{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "annapurna-sil";
  version = "1.204";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/annapurna/AnnapurnaSIL-${version}.zip";
    hash = "sha256-4ya3Iydrz5Pvol9sTDIe9ZW5k3+XQp8GB2LAnRpeiXs=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 OFL.txt OFL-FAQ.txt README.txt FONTLOG.txt -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://software.sil.org/annapurna";
    description = "Unicode-based font family with broad support for writing systems that use the Devanagari script";
    longDescription = ''
      Annapurna SIL is a Unicode-based font family with broad support for writing systems that use the Devanagari script. Inspired by traditional calligraphic forms, the design is intended to be highly readable, reasonably compact, and visually attractive.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.kmein ];
  };
}

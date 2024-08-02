{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "gentium-book-basic";
  version = "1.102";

  src = fetchzip {
    url = "http://software.sil.org/downloads/r/gentium/GentiumBasic_${lib.versions.major version}${lib.versions.minor version}.zip";
    hash = "sha256-oCmpl95MJRfCV25cg/4cf8AwQWnoymXasSss1ziOPoE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf                       -t $out/share/fonts/truetype
    install -Dm644 FONTLOG.txt GENTIUM-FAQ.txt -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://software.sil.org/gentium/";
    description = "High-quality typeface family for Latin, Cyrillic, and Greek";
    maintainers = [ ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}

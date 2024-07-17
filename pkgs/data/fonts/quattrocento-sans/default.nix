{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "quattrocento-sans";
  version = "2.0";

  src = fetchzip {
    url = "https://web.archive.org/web/20170709124317/http://www.impallari.com/media/releases/quattrocento-sans-v${version}.zip";
    stripRoot = false;
    hash = "sha256-L3aFZmaA94B9APxsp8bSBpocIlK3Ehvj/RFXVcW2nso=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 */*/QuattrocentoSans*.otf -t $out/share/fonts/opentype
    install -Dm644 */FONTLOG.txt             -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.impallari.com/quattrocentosans/";
    description = "A classic, elegant and sober sans-serif typeface";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}

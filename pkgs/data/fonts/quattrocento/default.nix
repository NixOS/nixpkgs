{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "quattrocento";
  version = "1.1";

  src = fetchzip {
    url = "https://web.archive.org/web/20170707001804/http://www.impallari.com/media/releases/quattrocento-v${version}.zip";
    hash = "sha256-ntY6Wl6TI8F7SShMyD8mdOxVg4oz9kvJ7vKTyGdPLtE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 */*.otf     -t $out/share/fonts/opentype
    install -Dm644 FONTLOG.txt -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.impallari.com/quattrocento/";
    description = "A classic, elegant, sober and strong serif typeface";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}

{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "barlow";
  version = "1.422";

  src = fetchzip {
    url = "https://tribby.com/fonts/barlow/download/barlow-${version}.zip";
    stripRoot = false;
    hash = "sha256-aHAGPEgBkH41r7HR0D74OGCa7ta7Uo8Mgq4YVtYOwU8=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/otf/*.otf -t $out/share/fonts/opentype
    install -Dm644 fonts/ttf/*.ttf fonts/gx/*.ttf -t $out/share/fonts/truetype
    install -Dm644 fonts/eot/*.eot -t $out/share/fonts/eot
    install -Dm644 fonts/woff/*.woff -t $out/share/fonts/woff
    install -Dm644 fonts/woff2/*.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  meta = with lib; {
    description = "A grotesk variable font superfamily";
    homepage = "https://tribby.com/fonts/barlow/";
    license = licenses.ofl;
    maintainers = [ ];
    platforms = platforms.all;
  };
}

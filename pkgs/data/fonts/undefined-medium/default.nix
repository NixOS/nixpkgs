{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "undefined-medium";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/andirueckel/undefined-medium/archive/v1.0.zip";
    hash = "sha256-HG+V7jR7dDI6LeoiCg/8F38lW8Zdo6CyLj2DXy/ff64=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/otf/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://undefined-medium.com/";
    description = "A pixel grid-based monospace typeface";
    longDescription = ''
      undefined medium is a free and open-source pixel grid-based
      monospace typeface suitable for programming, writing, and
      whatever else you can think of … it’s pretty undefined.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
  };
}

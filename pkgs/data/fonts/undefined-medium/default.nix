{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "undefined-medium";
  version = "1.3";

  src = fetchzip {
    url = "https://github.com/andirueckel/undefined-medium/archive/v1.3.zip";
    hash = "sha256-cVdk6a0xijAQ/18W5jalqRS7IiPufMJW27Scns+nbEY=";
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

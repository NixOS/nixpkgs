{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://undefined-medium.com/";
    description = "Pixel grid-based monospace typeface";
    longDescription = ''
      undefined medium is a free and open-source pixel grid-based
      monospace typeface suitable for programming, writing, and
      whatever else you can think of … it’s pretty undefined.
    '';
<<<<<<< HEAD
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
=======
    license = licenses.ofl;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

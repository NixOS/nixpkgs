{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation {
  pname = "pecita";
  version = "5.4";

  src = fetchurl {
    url = "http://pecita.eu/b/Pecita.otf";
    hash = "sha256-D9IZ+p4UFHUNt9me7D4vv0x6rMK9IaViKPliCEyX6t4=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    cp -v $src $out/share/fonts/opentype/Pecita.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://pecita.eu/police-en.php";
    description = "Handwritten font with connected glyphs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}

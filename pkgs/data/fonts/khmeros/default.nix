{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "khmeros";
  version = "5.0";

  src = fetchurl {
    url = "mirror://debian/pool/main/f/fonts-${pname}/fonts-${pname}_${version}.orig.tar.xz";
    hash = "sha256-gBcM9YHSuhbxvwfQTvywH/5kN921GOyvGtkROcmcBiw=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts
    cp *.ttf $out/share/fonts

    runHook postInstall
  '';

  meta = with lib; {
    description = "KhmerOS Unicode fonts for the Khmer language";
    homepage = "http://www.khmeros.info/";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}

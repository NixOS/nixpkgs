{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "cm-unicode";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/cm-unicode/cm-unicode/${version}/${pname}-${version}-otf.tar.xz";
    hash = "sha256-VIp+vk1IYbEHW15wMrfGVOPqg1zBZDpgFx+jlypOHCg=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/opentype *.otf
    install -m444 -Dt $out/share/doc/${pname}-${version}    README FontLog.txt

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://cm-unicode.sourceforge.io/";
    description = "Computer Modern Unicode fonts";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}

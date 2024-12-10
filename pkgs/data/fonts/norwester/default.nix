{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "norwester";
  version = "1.2";

  src = fetchzip {
    url = "http://jamiewilson.io/norwester/assets/norwester.zip";
    stripRoot = false;
    hash = "sha256-Ak/nobrQE/XYGWs/IhlZlTp74ff+s4adUR6Sht5Yf8g=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    cp ${pname}-v${version}/${pname}.otf $out/share/fonts/opentype/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://jamiewilson.io/norwester";
    description = "A condensed geometric sans serif by Jamie Wilson";
    maintainers = with maintainers; [ leenaars ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}

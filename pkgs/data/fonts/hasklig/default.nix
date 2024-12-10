{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hasklig";
  version = "1.1";

  src = fetchzip {
    url = "https://github.com/i-tu/Hasklig/releases/download/${version}/Hasklig-${version}.zip";
    stripRoot = false;
    hash = "sha256-jsPQtjuegMePt4tB1dZ9mq15LSxXBYwtakbq4od/sko=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/opentype *.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/i-tu/Hasklig";
    description = "A font with ligatures for Haskell code based off Source Code Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidrusu ];
  };
}

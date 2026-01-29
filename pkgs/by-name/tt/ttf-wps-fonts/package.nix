{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "ttf-wps-fonts";
  version = "0-unstable-2017-08-16";

  src = fetchFromGitHub {
    owner = "dv-anomaly";
    repo = "ttf-wps-fonts";
    rev = "b3e935355afcfb5240bac5a99707ffecc35772a2";
    hash = "sha256-oRVREnE3qsk4gl1W0yFC11bHr+cmuOJe9Ah+0Csplq8=";
  };


  installPhase = ''
    runHook preInstall

    FONT_PATH="$out/share/fonts/ttf-wps-fonts"
    mkdir -p $FONT_PATH
    cp *.ttf $FONT_PATH
    cp *.TTF $FONT_PATH
    chmod 644 $FONT_PATH/*

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/dv-anomaly/ttf-wps-fonts";
    description = "Fonts required by WPS Office";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ cdunster ];
    platforms = lib.platforms.all;
  };
}


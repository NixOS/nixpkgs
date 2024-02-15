{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "wps-fonts";
  version = "2017-08-16";

  src = fetchFromGitHub {
    owner = "dv-anomaly";
    repo = "wps-fonts";
    rev = "b3e935355afcfb5240bac5a99707ffecc35772a2";
    hash = "sha256-oRVREnE3qsk4gl1W0yFC11bHr+cmuOJe9Ah+0Csplq8=";
  };


  installPhase = ''
    FONT_PATH="$out/share/fonts/wps-fonts"
    echo -e "\nFonts will be installed in: "$FONT_PATH

    if [ ! -d "$FONT_PATH" ]; then
      echo "Creating Font Directory..."
      mkdir -p $FONT_PATH
    fi

    echo "Installing Fonts..."
    cp *.ttf $FONT_PATH
    cp *.TTF $FONT_PATH

    echo "Fixing Permissions..."
    chmod 644 $FONT_PATH/*

    echo "Installation Finished."
  '';

  meta = {
    homepage = "https://github.com/dv-anomaly/wps-fonts";
    description = "Fonts required by WPS Office";
    maintainers = with lib.maintainers; [ cdunster ];
  };
}


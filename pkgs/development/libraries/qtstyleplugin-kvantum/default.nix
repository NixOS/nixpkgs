{ stdenv, fetchFromGitHub, qmake, qtbase, qtsvg, qtx11extras, kwindowsystem
, libX11, libXext, qttools, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    sha256 = "1jcfv96ws6sm3kc2q8zriwqhry24qbq3zbp8gkqw75wssbv82rmc";
  };

  nativeBuildInputs = [
    qmake qttools wrapQtAppsHook
  ];
  buildInputs = [
    qtbase qtsvg qtx11extras kwindowsystem libX11 libXext
  ];

  sourceRoot = "source/Kvantum";

  postPatch = ''
    # Fix plugin dir
    substituteInPlace style/style.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
  '';

  meta = with stdenv.lib; {
    description = "SVG-based Qt5 theme engine plus a config tool and extra themes";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bugworm ];
  };
}

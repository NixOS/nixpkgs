{ lib, stdenv, fetchFromGitHub, qmake, qtbase, qtsvg, qtx11extras, kwindowsystem
, libX11, libXext, qttools, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    sha256 = "0k3j74klvd386ijsd4j09ccxlhga54z4pgnh36s9cv3rs7ab39qm";
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

  meta = with lib; {
    description = "SVG-based Qt5 theme engine plus a config tool and extra themes";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    broken = lib.versionOlder qtbase.version "5.14";
    maintainers = [ maintainers.bugworm ];
  };
}

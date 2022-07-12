{ lib, stdenv, fetchFromGitHub, qmake, qtbase, qtsvg, qtx11extras, kwindowsystem
, libX11, libXext, qttools, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    sha256 = "hY8QQVcP3E+GAdLOqtVbqCWBcxS2M6sMOr/vr+DryyQ=";
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

  passthru.updateScript = gitUpdater {
    inherit pname version;
    attrPath = "libsForQt5.${pname}";
    rev-prefix = "V";
  };

  meta = with lib; {
    description = "SVG-based Qt5 theme engine plus a config tool and extra themes";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    broken = lib.versionOlder qtbase.version "5.14";
    maintainers = [ maintainers.bugworm ];
  };
}

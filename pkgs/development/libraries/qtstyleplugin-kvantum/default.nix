{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, qmake
, qtbase
, qtsvg
, qtx11extras
, kwindowsystem
, libX11
, libXext
, qttools
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    sha256 = "5/cScJpi5Z5Z/SjizKfMTGytuEo2uUT6QtpMnn7JhKc=";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
    qtx11extras
    kwindowsystem
    libX11
    libXext
  ];

  sourceRoot = "source/Kvantum";

  patches = [
    (fetchpatch {
      # add xdg dirs support
      url = "https://github.com/tsujan/Kvantum/commit/01989083f9ee75a013c2654e760efd0a1dea4a68.patch";
      hash = "sha256-HPx+p4Iek/Me78olty1fA0dUNceK7bwOlTYIcQu8ycc=";
      stripLen = 1;
    })
  ];

  postPatch = ''
    # Fix plugin dir
    substituteInPlace style/style.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "V";
  };

  meta = with lib; {
    description = "SVG-based Qt5 theme engine plus a config tool and extra themes";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    broken = lib.versionOlder qtbase.version "5.14";
    maintainers = [ maintainers.romildo ];
  };
}

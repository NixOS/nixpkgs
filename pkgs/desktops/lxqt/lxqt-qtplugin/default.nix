{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, lxqt-build-tools
, qtbase
, qtx11extras
, qttools
, qtsvg
, libdbusmenu
, libqtxdg
, libfm-qt
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "lxqt-qtplugin";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0if01bdhz8ph4k1mwvjjjw0fw6mxzprgz17ap23xbsdr009hxdf0";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    qtsvg
    libdbusmenu
    libqtxdg
    libfm-qt
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace "DESTINATION \"\''${QT_PLUGINS_DIR}" "DESTINATION \"$qtPluginPrefix"
  '';

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    description = "LXQt Qt platform integration plugin";
    homepage = "https://github.com/lxqt/lxqt-qtplugin";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}

{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, libdbusmenu
, libfm-qt
, libqtxdg
, lxqt-build-tools
, lxqtUpdateScript
, qtbase
, qtsvg
, qttools
, qtx11extras
}:

mkDerivation rec {
  pname = "lxqt-qtplugin";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "14k5icxjkl5znp59y44791brsmwy54jkwr4vn3kg4ggqjdp3vbh9";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    libdbusmenu
    libfm-qt
    libqtxdg
    qtbase
    qtsvg
    qttools
    qtx11extras
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

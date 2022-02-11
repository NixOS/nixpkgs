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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1vr2hlv1q9xwkh9bapy29g9fi90d33xw7pr9zc1bfma6j152qs36";
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
    homepage = "https://github.com/lxqt/lxqt-qtplugin";
    description = "LXQt Qt platform integration plugin";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}

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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "17x5jr78rbsf4pbvc4y3wwkpvsmynzkxy2ifvwhqyc2gmjspp8il";
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

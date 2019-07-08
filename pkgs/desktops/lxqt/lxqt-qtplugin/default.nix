{
  stdenv, fetchFromGitHub,
  cmake, lxqt-build-tools,
  qtbase, qtx11extras, qttools, qtsvg, libdbusmenu, libqtxdg, libfm-qt
}:

stdenv.mkDerivation rec {
  pname = "lxqt-qtplugin";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "16n50lxnya03zcviw65sy5dyg9dsrn64k91mrqfvraf6d90md4al";
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

  meta = with stdenv.lib; {
    description = "LXQt Qt platform integration plugin";
    homepage = https://github.com/lxqt/lxqt-qtplugin;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}

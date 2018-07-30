{
  stdenv, fetchFromGitHub,
  cmake, lxqt-build-tools,
  qtbase, qtx11extras, qttools, qtsvg, libdbusmenu, libqtxdg, libfm-qt
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-qtplugin";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "19y5dvbj7gwyh8glc6vi6hb5snvkd3jwvss6j0sn2sy2gp9g9ryb";
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

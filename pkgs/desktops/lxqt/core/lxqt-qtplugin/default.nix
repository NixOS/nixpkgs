{
  stdenv, fetchFromGitHub,
  cmake, lxqt-build-tools,
  qtbase, qtx11extras, qttools, qtsvg, libdbusmenu, libqtxdg, libfm-qt
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-qtplugin";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1i1rga0pg764ccwhq7acdsckxpl1apxwj4lv4gygxxmpkrg62zkv";
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
    homepage = https://github.com/lxde/lxqt-qtplugin;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}

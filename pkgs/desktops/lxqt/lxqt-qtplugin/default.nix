{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, libdbusmenu
, libfm-qt
, libqtxdg
, lxqt-build-tools
, gitUpdater
, qtbase
, qtsvg
, qttools
, qtx11extras
}:

mkDerivation rec {
  pname = "lxqt-qtplugin";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "/phBrpSru/4m+mcAkn4C6hKm5H2BAXNkbTgU2HmoyBg=";
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

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-qtplugin";
    description = "LXQt Qt platform integration plugin";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}

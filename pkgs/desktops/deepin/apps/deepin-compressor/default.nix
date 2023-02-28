{ stdenv
, lib
, fetchFromGitHub
, dtkwidget
, qt5integration
, qt5platform-plugins
, udisks2-qt5
, cmake
, qtbase
, qttools
, pkg-config
, kcodecs
, karchive
, wrapQtAppsHook
, minizip
, libzip
, libarchive
}:

stdenv.mkDerivation rec {
  pname = "deepin-compressor";
  version = "5.12.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-HJDtUvXUT94G4WqrK92UMmijnuC4ApkKHU3yE3rOKHQ=";
  };

  postPatch = ''
    substituteInPlace src/source/common/pluginmanager.cpp \
      --replace "/usr/lib/" "$out/lib/"
    substituteInPlace src/desktop/deepin-compressor.desktop \
      --replace "/usr" "$out"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5platform-plugins
    udisks2-qt5
    kcodecs
    karchive
    minizip
    libzip
    libarchive
  ];

  cmakeFlags = [
    "-DVERSION=${version}"
    "-DUSE_TEST=OFF"
  ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  meta = with lib; {
    description = "A fast and lightweight application for creating and extracting archives";
    homepage = "https://github.com/linuxdeepin/deepin-compressor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}

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
, libuuid
, libarchive
}:

stdenv.mkDerivation rec {
  pname = "deepin-compressor";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-DUpYb1xNmWpBcKo9kajeVm/+z4yj2OBE+qOyEkCHbUI=";
  };

  postPatch = ''
    substituteInPlace src/source/common/pluginmanager.cpp \
      --replace-fail "/usr/lib" "$out/lib"
    substituteInPlace src/desktop/deepin-compressor.desktop \
      --replace-fail "/usr" "$out"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
    udisks2-qt5
    kcodecs
    karchive
    minizip
    libzip
    libuuid
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

  strictDeps = true;

  meta = with lib; {
    description = "Fast and lightweight application for creating and extracting archives";
    mainProgram = "deepin-compressor";
    homepage = "https://github.com/linuxdeepin/deepin-compressor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}

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
  version = "5.12.17";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-eg9JcuBTKoaEuoph0rvy0VRH28sFOdYWN9sGbduUwcM=";
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

  strictDeps = true;

  meta = with lib; {
    description = "A fast and lightweight application for creating and extracting archives";
    homepage = "https://github.com/linuxdeepin/deepin-compressor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}

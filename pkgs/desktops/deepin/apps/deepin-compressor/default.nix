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
<<<<<<< HEAD
, libuuid
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libarchive
}:

stdenv.mkDerivation rec {
  pname = "deepin-compressor";
<<<<<<< HEAD
  version = "5.12.17";
=======
  version = "5.12.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-eg9JcuBTKoaEuoph0rvy0VRH28sFOdYWN9sGbduUwcM=";
=======
    sha256 = "sha256-0F1LdoeGtIKOVepifwdNMohbEb9fakpQLiNHg5H9Nlw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    libuuid
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

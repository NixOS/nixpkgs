{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, dtkwidget
, qt5integration
, qt5platform-plugins
, qtbase
, qtsvg
, dde-qt-dbus-factory
, kcodecs
, syntax-highlighting
, libchardet
, libuchardet
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "deepin-editor";
<<<<<<< HEAD
  version = "6.0.11";
=======
  version = "6.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-OdKEskxrzFo4VOsR2+rsH3G63uqMmsBuXufayHWSQac=";
=======
    sha256 = "sha256-7dHSybjoWZ1alcMsMm4BEEQJjQgNmhC7Eskeo3ZmoS8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
    qtbase
    qtsvg
    dde-qt-dbus-factory
    kcodecs
    syntax-highlighting
    libchardet
    libuchardet
    libiconv
  ];

  strictDeps = true;

  cmakeFlags = [ "-DVERSION=${version}" ];

  meta = with lib; {
    description = "A desktop text editor that supports common text editing features";
    homepage = "https://github.com/linuxdeepin/deepin-editor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}

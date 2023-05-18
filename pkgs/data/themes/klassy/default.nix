{ lib
, stdenv
, kdecoration
, qt5
, cmake
, extra-cmake-modules
, plasma-workspace
, qtbase
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "klassy";
  version = "4.3.breeze5.27.5";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = "klassy";
    rev = version;
    sha256 = "2qs30L7U5kf1Yf+4Pgsjsyaqf9iIaeuRK25Xtn47AYI=";
  };

  buildInputs = [
    kdecoration
    plasma-workspace
    qtbase
    qt5.qtx11extras
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "Klassy (formerly ClassiK/ClassikStyles) is a highly customizable binary Window Decoration and Application Style plugin for recent versions of the KDE Plasma desktop";
    homepage = "https://github.com/paulmcauley/klassy";
    license = licenses.gpl2;
    maintainers = [ maintainers.hikari ];
    platforms = platforms.linux;
  };
}


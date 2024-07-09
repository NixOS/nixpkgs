{ mkDerivation
, lib
, kdecoration
, fetchFromGitHub
, cmake
, extra-cmake-modules
, plasma-workspace
, qtbase
, qt5
}:

mkDerivation rec {
  pname = "lightly-boehs";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "boehs";
    repo = "Lightly";
    rev = "1a831f7ff19ce93c04489faec74e389a216fdf11";
    sha256 = "Icw+xVmuCB59ltyZJKyIeHI/yGfM2SbPrVzTVLqHWd4=";
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
    description = "Fork of the Lightly breeze theme style that aims to be visually modern and minimalistic";
    mainProgram = "lightly-settings5";
    homepage = "https://github.com/boehs/Lightly";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.hikari ];
    platforms = platforms.all;
  };
}

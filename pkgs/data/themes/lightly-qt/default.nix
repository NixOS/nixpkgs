{ mkDerivation
, lib
, fetchFromGitHub
, cmake
, extra-cmake-modules
, kdecoration
, plasma-workspace
, qtbase
, qt5
}:

mkDerivation rec {
  pname = "lightly-qt";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Luwx";
    repo = "Lightly";
    rev = "v${version}";
    sha256 = "0qkjzgjplgwczhk6959iah4ilvazpprv7yb809jy75kkp1jw8mwk";
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
    description = "A fork of breeze theme style that aims to be visually modern and minimalistic";
    mainProgram = "lightly-settings5";
    homepage = "https://github.com/Luwx/Lightly";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.pwoelfel ];
    platforms = platforms.all;
  };
}

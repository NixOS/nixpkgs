{ lib
, mkDerivation
, fetchFromGitHub
, extra-cmake-modules
, kwindowsystem
, plasma-framework
, qtx11extras
}:

mkDerivation rec {
  pname = "plasma-applet-virtual-desktop-bar";
  version = "unstable-2021-02-20";

  src = fetchFromGitHub {
    owner = "wsdfhjxc";
    repo = "virtual-desktop-bar";
    rev = "3e9bbddb8def8da65071a1c325eaa06598e8a473";
    sha256 = "192ns6c2brzq46pg385n0v1ydbz52aaa8f5dgfw5251hrw9c7bxg";
  };

  buildInputs = [
    kwindowsystem
    plasma-framework
    qtx11extras
  ];

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  cmakeFlags = [
    "-Wno-dev"
  ];

  meta = with lib; {
    description = "Manage virtual desktops dynamically in a convenient way";
    homepage = "https://github.com/wsdfhjxc/virtual-desktop-bar";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}

{
  stdenv,
  lib,

  fetchFromGitLab,

  meson,
  pkg-config,
  cmake,
  qttools,
  ninja,

  qtbase,
  wlroots,
  wayland
}:

stdenv.mkDerivation {
  pname = "wayqt";
  version = "unstable-2022-09-27";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "wayqt";
    rev = "64b9a4a33e7385f5bc977b8ca1d3ed283bcd89c9";
    hash = "sha256-S/ncDoRmg/k5c2zPjZZvxNfqFgI+3QHh+iavIuY/fac=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    cmake
    qttools # lrelease
    ninja
  ];

  buildInputs = [
    qtbase
    wlroots
    wayland
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://gitlab.com/desktop-frameworks/wayqt";
    description = "Qt-based library to handle Wayland and Wlroots protocols to be used with any Qt project";
    maintainers = with maintainers; [ atemu ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}

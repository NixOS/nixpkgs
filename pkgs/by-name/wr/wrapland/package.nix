{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  wayland-scanner,
  kdePackages,

  wayland,
  microsoft-gsl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wrapland";
  version = "0.602.0";

  src = fetchFromGitHub {
    owner = "winft";
    repo = "wrapland";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-1e756nGuUwq96WCLHS/BB/dG2cYcFjpEOWKmSw1PAPk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wayland-scanner
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
    qtbase
    wayland-protocols
    wayland
    microsoft-gsl
  ];

  meta = {
    description = "Qt/C++ library wrapping libwayland";
    homepage = "https://github.com/winft/wrapland";
    license = with lib.licenses; [ lgpl2Only ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.linux;
  };
})

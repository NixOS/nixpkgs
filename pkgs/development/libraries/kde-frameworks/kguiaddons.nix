{
  lib,
  stdenv,
  mkDerivation,
  cmake,
  pkg-config,
  extra-cmake-modules,
  wayland-scanner,
  qtbase,
  qtx11extras,
  wayland,
  kdePackages,
}:

mkDerivation {
  pname = "kguiaddons";

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland-scanner
  ];
  buildInputs = [
    qtx11extras
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    kdePackages.plasma-wayland-protocols
  ];
  propagatedBuildInputs = [ qtbase ];

  outputs = [
    "out"
    "dev"
  ];

  meta.homepage = "https://invent.kde.org/frameworks/kguiaddons";
}

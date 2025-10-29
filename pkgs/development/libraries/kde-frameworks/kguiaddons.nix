{
  lib,
  stdenv,
  mkDerivation,
  extra-cmake-modules,
  wayland-scanner,
  qtbase,
  qtx11extras,
  wayland,
  plasma-wayland-protocols,
}:

mkDerivation {
  pname = "kguiaddons";

  nativeBuildInputs = [
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
    plasma-wayland-protocols
  ];
  propagatedBuildInputs = [ qtbase ];

  outputs = [
    "out"
    "dev"
  ];

  meta.homepage = "https://invent.kde.org/frameworks/kguiaddons";
}

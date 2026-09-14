{
  mkDerivation,
  lib,
  stdenv,
  cmake,
  extra-cmake-modules,
  kcodecs,
  kconfig,
  kcoreaddons,
  kwindowsystem,
  libcanberra,
  qttools,
  qtx11extras,
  qtmacextras,
  libdbusmenu-qt5,
}:

mkDerivation {
  pname = "knotifications";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qttools
  ];
  buildInputs = [
    kcodecs
    kconfig
    kcoreaddons
    kwindowsystem
    libcanberra
    qtx11extras
    libdbusmenu-qt5
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    qtmacextras
  ];
}

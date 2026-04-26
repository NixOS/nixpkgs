{
  mkDerivation,
  lib,
  stdenv,
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

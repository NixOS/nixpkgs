{
  mkDerivation,
  lib,
  stdenv,
  extra-cmake-modules,
  kcodecs,
  kconfig,
  kcoreaddons,
  kwindowsystem,
  phonon,
  qttools,
  qtx11extras,
  qtmacextras,
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
    phonon
    qtx11extras
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    qtmacextras
  ];
}

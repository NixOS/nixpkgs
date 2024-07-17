{
  mkDerivation,
  extra-cmake-modules,
  kconfig,
  knotifications,
  ki18n,
  solid,
  kcoreaddons,
  kdeclarative,
  kcmutils,
  kpackage,
  kscreenlocker,
  kwindowsystem,
  wayland,
  pkg-config,
  libcec,
  libcec_platform,
  libevdev,
  plasma-workspace,
  plasma-wayland-protocols,
}:
mkDerivation {
  pname = "plasma-remotecontrollers";
  nativeBuildInputs = [
    extra-cmake-modules
    pkg-config
  ];
  buildInputs = [
    kconfig
    knotifications
    ki18n
    solid
    kcoreaddons
    kdeclarative
    kcmutils
    kpackage
    kscreenlocker
    kwindowsystem
    wayland
    libcec
    libcec_platform
    libevdev
    plasma-workspace
    plasma-wayland-protocols
  ];
}

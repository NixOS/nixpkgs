{
  mkDerivation, extra-cmake-modules, kdoctools, kcmutils, kconfig, khtml,
  ki18n, kiconthemes, kio, kwindowsystem, libpwquality
}:

mkDerivation {
  name = "user-manager";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kconfig khtml ki18n kiconthemes kio kwindowsystem
    libpwquality
  ];
}

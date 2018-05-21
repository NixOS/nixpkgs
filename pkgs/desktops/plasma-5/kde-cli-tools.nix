{
  mkDerivation, extra-cmake-modules, kdoctools,
  kcmutils, kconfig, kdesu, ki18n, kiconthemes, kinit, kio, kwindowsystem,
  qtsvg, qtx11extras, kactivities, plasma-workspace
}:

mkDerivation {
  name = "kde-cli-tools";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kconfig kdesu ki18n kiconthemes kinit kio kwindowsystem qtsvg
    qtx11extras kactivities plasma-workspace
  ];
}

{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kconfig, kconfigwidgets, kcoreaddons, kcmutils, kholidays,
  kio, knewstuff, kpurpose, kross, krunner, kservice,
  kunitconversion, ibus, plasma-framework, plasma-workspace, qtdeclarative,
  qtwebengine, qtx11extras
}:

mkDerivation {
  pname = "kdeplasma-addons";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kconfigwidgets kcoreaddons kcmutils kholidays kio
    knewstuff kpurpose kross krunner kservice kunitconversion ibus
    plasma-framework plasma-workspace qtdeclarative qtwebengine qtx11extras
  ];
}

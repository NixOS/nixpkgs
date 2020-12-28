{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  qtbase,
  kcmutils, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons,
  kdeclarative, kdelibs4support, ki18n, kiconthemes, kio, kirigami2, kpackage,
  kservice, kwayland, kwidgetsaddons, kxmlgui,
  systemsettings,
  libraw1394, libGLU, pciutils, solid,
}:

mkDerivation {
  name = "kinfocenter";
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kcompletion kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kdelibs4support ki18n kiconthemes kio kirigami2 kpackage
    kservice kwayland kwidgetsaddons kxmlgui libraw1394 libGLU pciutils solid
  ];

  # it doesn't detect systemsettings when added to buildInputs so manually symlink it
  postInstall = ''
    ln -sf ${systemsettings}/bin/systemsettings5 $out/bin/kinfocenter
  '';
}

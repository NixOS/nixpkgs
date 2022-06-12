{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  qtbase,
  kcmutils, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons,
  kdeclarative, ki18n, kiconthemes, kio, kirigami2, kpackage, kservice,
  kwayland, kwidgetsaddons, kxmlgui, solid, systemsettings,
  libraw1394, libGLU, pciutils,
}:

mkDerivation {
  pname = "kinfocenter";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kcompletion kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative ki18n kiconthemes kio kirigami2 kpackage kservice kwayland
    kwidgetsaddons kxmlgui solid systemsettings

    libraw1394 libGLU pciutils
  ];
  preFixup = ''
    # fix wrong symlink of infocenter pointing to a 'systemsettings5' binary in
    # the same directory, while it is actually located in a completely different
    # store path
    ln -sf ${lib.getBin systemsettings}/bin/systemsettings5 $out/bin/kinfocenter
  '';
}

{ mkDerivation
, extra-cmake-modules
, kdoctools
, kcmutils
, kcompletion
, kconfig
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdeclarative
, kdelibs4support
, ki18n
, kiconthemes
, kio
, kpackage
, kservice
, kwidgetsaddons
, kxmlgui
, libraw1394
, pciutils
, solid
}:

mkDerivation {
  name = "kinfocenter";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcmutils
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kdeclarative
    kdelibs4support
    ki18n
    kiconthemes
    kio
    kpackage
    kservice
    kwidgetsaddons
    kxmlgui
    libraw1394
    pciutils
    solid
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kinfocenter"
  '';
}

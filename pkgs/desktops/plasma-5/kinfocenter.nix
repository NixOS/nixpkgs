{ mkDerivation
, lib
, extra-cmake-modules
, kdoctools
, qtbase
, kcmutils
, kcompletion
, kconfig
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdeclarative
, ki18n
, kiconthemes
, kio
, kirigami2
, kpackage
, kservice
, kwayland
, kwidgetsaddons
, kxmlgui
, solid
, systemsettings
, libraw1394
, libGLU
, pciutils
, aha
, glxinfo
, vulkan-tools
, wayland-utils
, xdpyinfo
}:

mkDerivation {
  pname = "kinfocenter";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kdeclarative
    ki18n
    kiconthemes
    kio
    kirigami2
    kpackage
    kservice
    kwayland
    kwidgetsaddons
    kxmlgui
    solid
    systemsettings

    libraw1394
    libGLU
    pciutils
  ];
  postFixup = ''
    rm $out/bin/kinfocenter
    # 'kinfocenter' simply opens 'systemsettings5', which checks
    # the executable name to see in which mode it should open
    makeWrapper ${lib.getBin systemsettings}/bin/systemsettings5 $out/bin/kinfocenter \
      --argv0 $pname \
      --prefix PATH : ${lib.makeBinPath [ aha glxinfo pciutils vulkan-tools wayland-utils xdpyinfo ]}
  '';
}

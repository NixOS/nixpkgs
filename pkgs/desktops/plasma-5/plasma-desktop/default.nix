{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,

  boost, fontconfig, ibus, libXcursor, libXft, libcanberra_kde, libpulseaudio,
  libxkbfile, xf86inputevdev, xf86inputsynaptics, xinput, xkeyboard_config,
  xorgserver, util-linux,

  qtdeclarative, qtquickcontrols, qtquickcontrols2, qtsvg, qtx11extras,

  attica, baloo, kactivities, kactivities-stats, kauth, kcmutils, kdbusaddons,
  kdeclarative, kded, kdelibs4support, kemoticons, kglobalaccel, ki18n,
  kitemmodels, knewstuff, knotifications, knotifyconfig, kpeople, krunner,
  kscreenlocker, ksysguard, kwallet, kwin, phonon, plasma-framework,
  plasma-workspace, qqc2-desktop-style, xf86inputlibinput
}:

mkDerivation {
  name = "plasma-desktop";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    boost fontconfig ibus libcanberra_kde libpulseaudio libXcursor libXft xorgserver
    libxkbfile phonon xf86inputevdev xf86inputsynaptics xinput xkeyboard_config

    qtdeclarative qtquickcontrols qtquickcontrols2 qtsvg qtx11extras

    attica baloo kactivities kactivities-stats kauth kcmutils kdbusaddons
    kdeclarative kded kdelibs4support kemoticons kglobalaccel ki18n kitemmodels
    knewstuff knotifications knotifyconfig kpeople krunner kscreenlocker
    ksysguard kwallet kwin plasma-framework plasma-workspace qqc2-desktop-style
  ];

  patches = [
    ./hwclock-path.patch
    ./tzdir.patch
  ];
  postPatch = ''
    sed '1i#include <cmath>' -i kcms/touchpad/backends/x11/synapticstouchpad.cpp
  '';
  CXXFLAGS = [
    "-I${lib.getDev xorgserver}/include/xorg"
    ''-DNIXPKGS_HWCLOCK=\"${lib.getBin util-linux}/sbin/hwclock\"''
  ];
  cmakeFlags = [
    "-DEvdev_INCLUDE_DIRS=${lib.getDev xf86inputevdev}/include/xorg"
    "-DSynaptics_INCLUDE_DIRS=${lib.getDev xf86inputsynaptics}/include/xorg"
    "-DXORGLIBINPUT_INCLUDE_DIRS=${lib.getDev xf86inputlibinput}/include/xorg"
  ];
  postInstall = ''
    # Display ~/Desktop contents on the desktop by default.
    sed -i "''${!outputBin}/share/plasma/shells/org.kde.plasma.desktop/contents/defaults" \
        -e 's/Containment=org.kde.desktopcontainment/Containment=org.kde.plasma.folder/'
  '';
}

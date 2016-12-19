{
  plasmaPackage, substituteAll,
  ecm, kdoctools,
  attica, baloo, boost, fontconfig, ibus, kactivities, kactivities-stats, kauth,
  kcmutils, kdbusaddons, kdeclarative, kded, kdelibs4support, kemoticons,
  kglobalaccel, ki18n, kitemmodels, knewstuff, knotifications, knotifyconfig,
  kpeople, krunner, ksysguard, kwallet, kwin, libXcursor, libXft,
  libcanberra_kde, libpulseaudio, libxkbfile, phonon, plasma-framework,
  plasma-workspace, qtdeclarative, qtquickcontrols, qtsvg, qtx11extras, xf86inputevdev,
  xf86inputsynaptics, xinput, xkeyboard_config, xorgserver, utillinux
}:

plasmaPackage rec {
  name = "plasma-desktop";
  nativeBuildInputs = [ ecm kdoctools ];
  buildInputs = [
    attica boost fontconfig ibus kcmutils kdbusaddons kded kitemmodels knewstuff
    knotifications knotifyconfig kwallet libcanberra_kde libXcursor
    libpulseaudio libXft libxkbfile phonon qtsvg xf86inputevdev
    xf86inputsynaptics xkeyboard_config xinput baloo kactivities
    kactivities-stats kauth kdeclarative kdelibs4support kemoticons kglobalaccel
    ki18n kpeople krunner kwin plasma-framework plasma-workspace qtdeclarative
    qtquickcontrols qtx11extras ksysguard
  ];
  patches = [
    ./0001-qt-5.5-QML-import-paths.patch
    (substituteAll {
      src = ./0002-hwclock.patch;
      hwclock = "${utillinux}/sbin/hwclock";
    })
    ./0003-tzdir.patch
  ];
  postPatch = ''
    sed '1i#include <cmath>' -i kcms/touchpad/src/backends/x11/synapticstouchpad.cpp
  '';
  NIX_CFLAGS_COMPILE = [ "-I${xorgserver.dev}/include/xorg" ];
  cmakeFlags = [
    "-DEvdev_INCLUDE_DIRS=${xf86inputevdev.dev}/include/xorg"
    "-DSynaptics_INCLUDE_DIRS=${xf86inputsynaptics.dev}/include/xorg"
  ];
  postInstall = ''
    # Display ~/Desktop contents on the desktop by default.
    sed -i "$out/share/plasma/shells/org.kde.plasma.desktop/contents/defaults" \
        -e 's/Containment=org.kde.desktopcontainment/Containment=org.kde.plasma.folder/'
  '';
}

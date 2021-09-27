{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,

  boost, fontconfig, ibus, libXcursor, libXft, libcanberra_kde, libpulseaudio,
  libxkbfile, xf86inputevdev, xf86inputsynaptics, xinput, xkeyboard_config,
  xorgserver, util-linux,

  accounts-qt, qtdeclarative, qtquickcontrols, qtquickcontrols2, qtsvg,
  qtx11extras,

  attica, baloo, kaccounts-integration, kactivities, kactivities-stats, kauth,
  kcmutils, kdbusaddons, kdeclarative, kded, kdelibs4support, kemoticons,
  kglobalaccel, ki18n, kitemmodels, knewstuff, knotifications, knotifyconfig,
  kpeople, krunner, kscreenlocker, kwallet, kwin, phonon,
  plasma-framework, plasma-workspace, qqc2-desktop-style, xf86inputlibinput
}:

mkDerivation {
  name = "plasma-desktop";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    boost fontconfig ibus libcanberra_kde libpulseaudio libXcursor libXft xorgserver
    libxkbfile phonon xf86inputlibinput xf86inputevdev xf86inputsynaptics xinput
    xkeyboard_config

    accounts-qt qtdeclarative qtquickcontrols qtquickcontrols2 qtsvg qtx11extras

    attica baloo kaccounts-integration kactivities kactivities-stats kauth
    kcmutils kdbusaddons kdeclarative kded kdelibs4support kemoticons
    kglobalaccel ki18n kitemmodels knewstuff knotifications knotifyconfig
    kpeople krunner kscreenlocker kwallet kwin plasma-framework
    plasma-workspace qqc2-desktop-style
  ];

  patches = [
    ./hwclock-path.patch
    ./tzdir.patch
  ];
  CXXFLAGS = [
    ''-DNIXPKGS_HWCLOCK=\"${lib.getBin util-linux}/sbin/hwclock\"''
  ];
  postInstall = ''
    # Display ~/Desktop contents on the desktop by default.
    sed -i "''${!outputBin}/share/plasma/shells/org.kde.plasma.desktop/contents/defaults" \
        -e 's/Containment=org.kde.desktopcontainment/Containment=org.kde.plasma.folder/'
  '';
}

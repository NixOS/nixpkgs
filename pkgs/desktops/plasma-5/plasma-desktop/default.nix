{ mkDerivation
, lib
, extra-cmake-modules
, kdoctools
, wayland-scanner
, boost
, fontconfig
, ibus
, libXcursor
, libXft
, libcanberra_kde
, libpulseaudio
, libxkbfile
, xf86inputevdev
, xf86inputsynaptics
, xinput
, xkeyboard_config
, xorgserver
, util-linux
, wayland
, wayland-protocols
, accounts-qt
, qtdeclarative
, qtquickcontrols
, qtquickcontrols2
, qtsvg
, qtx11extras
, attica
, baloo
, kaccounts-integration
, kactivities
, kactivities-stats
, kauth
, kcmutils
, kdbusaddons
, kdeclarative
, kded
, kdelibs4support
, kemoticons
, kglobalaccel
, ki18n
, kitemmodels
, knewstuff
, knotifications
, knotifyconfig
, kpeople
, krunner
, kscreenlocker
, kwallet
, kwin
, phonon
, plasma-framework
, plasma-workspace
, qqc2-desktop-style
, xf86inputlibinput
, glib
, gsettings-desktop-schemas
, runCommandLocal
, makeWrapper
}:
let
  # run gsettings with desktop schemas for using in "kcm_access" kcm
  # and in kaccess
  gsettings-wrapper = runCommandLocal "gsettings-wrapper" { nativeBuildInputs = [ makeWrapper ]; } ''
    mkdir -p $out/bin
    makeWrapper ${glib}/bin/gsettings $out/bin/gsettings --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas.out}/share/gsettings-schemas/${gsettings-desktop-schemas.name}
  '';
in
mkDerivation {
  pname = "plasma-desktop";
  nativeBuildInputs = [ extra-cmake-modules kdoctools wayland-scanner ];
  buildInputs = [
    boost
    fontconfig
    ibus
    libcanberra_kde
    libpulseaudio
    libXcursor
    libXft
    xorgserver
    libxkbfile
    phonon
    xf86inputlibinput
    xf86inputevdev
    xf86inputsynaptics
    xinput
    xkeyboard_config
    wayland
    wayland-protocols

    accounts-qt
    qtdeclarative
    qtquickcontrols
    qtquickcontrols2
    qtsvg
    qtx11extras

    attica
    baloo
    kaccounts-integration
    kactivities
    kactivities-stats
    kauth
    kcmutils
    kdbusaddons
    kdeclarative
    kded
    kdelibs4support
    kemoticons
    kglobalaccel
    ki18n
    kitemmodels
    knewstuff
    knotifications
    knotifyconfig
    kpeople
    krunner
    kscreenlocker
    kwallet
    kwin
    plasma-framework
    plasma-workspace
    qqc2-desktop-style
  ];

  patches = [
    ./hwclock-path.patch
    ./tzdir.patch
    ./kcm-access.patch
    ./no-discover-shortcut.patch
  ];
  CXXFLAGS =
    [
      ''-DNIXPKGS_HWCLOCK=\"${lib.getBin util-linux}/bin/hwclock\"''
      ''-DNIXPKGS_GSETTINGS=\"${gsettings-wrapper}/bin/gsettings\"''
    ];
  postInstall = ''
    # Display ~/Desktop contents on the desktop by default.
    sed -i "''${!outputBin}/share/plasma/shells/org.kde.plasma.desktop/contents/defaults" \
        -e 's/Containment=org.kde.desktopcontainment/Containment=org.kde.plasma.folder/'
  '';

  # wrap kaccess with wrapped gsettings so it can access accessibility schemas
  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ gsettings-wrapper ]}" ];
}

{ plasmaPackage, substituteAll, extra-cmake-modules, kdoctools
, attica, baloo, boost, fontconfig, kactivities, kauth, kcmutils
, kdbusaddons, kdeclarative, kded, kdelibs4support, kemoticons
, kglobalaccel, ki18n, kitemmodels, knewstuff, knotifications
, knotifyconfig, kpeople, krunner, kwallet, kwin, phonon
, plasma-framework, plasma-workspace, qtdeclarative, qtx11extras
, qtsvg, libXcursor, libXft, libxkbfile, xf86inputevdev
, xf86inputsynaptics, xinput, xkeyboard_config, xorgserver
, libcanberra_kde, libpulseaudio, makeKDEWrapper, utillinux
}:

plasmaPackage rec {
  name = "plasma-desktop";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeKDEWrapper
  ];
  buildInputs = [
    attica boost fontconfig kcmutils kdbusaddons kded kitemmodels
    knewstuff knotifications knotifyconfig kwallet libcanberra_kde
    libXcursor libpulseaudio libXft libxkbfile phonon
    qtsvg xf86inputevdev xf86inputsynaptics
    xkeyboard_config xinput
  ];
  propagatedBuildInputs = [
    baloo kactivities kauth kdeclarative kdelibs4support kemoticons
    kglobalaccel ki18n kpeople krunner kwin plasma-framework
    plasma-workspace qtdeclarative qtx11extras
  ];
  # All propagatedBuildInputs should be present in the profile because
  # wrappers cannot be used here.
  propagatedUserEnvPkgs = propagatedBuildInputs;
  patches = [
    (substituteAll {
      src = ./0001-hwclock.patch;
      hwclock = "${utillinux}/sbin/hwclock";
    })
    ./0002-zoneinfo.patch
  ];
  NIX_CFLAGS_COMPILE = [ "-I${xorgserver}/include/xorg" ];
  cmakeFlags = [
    "-DEvdev_INCLUDE_DIRS=${xf86inputevdev}/include/xorg"
    "-DSynaptics_INCLUDE_DIRS=${xf86inputsynaptics}/include/xorg"
  ];
  postInstall = ''
    # These files are installed in the wrong location.
    cd "$out/share/plasma/plasmoids/org.kde.desktopcontainment/contents"
    mv "code/LayoutManager.js" "ui/LayoutManager.js"
    cd "$out/share/plasma/plasmoids/org.kde.panel/contents"
    mv "code/LayoutManager.js" "ui/LayoutManager.js"

    cd "$NIX_BUILD_TOP"

    wrapKDEProgram "$out/bin/kaccess"
    wrapKDEProgram "$out/bin/solid-action-desktop-gen"
    wrapKDEProgram "$out/bin/knetattach"
    wrapKDEProgram "$out/bin/krdb"
    wrapKDEProgram "$out/bin/kapplymousetheme"
    wrapKDEProgram "$out/bin/kfontinst"
    wrapKDEProgram "$out/bin/kcm-touchpad-list-devices"
    wrapKDEProgram "$out/bin/kfontview"
  '';
}

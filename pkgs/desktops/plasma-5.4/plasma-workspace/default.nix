{ plasmaPackage
, extra-cmake-modules
, kdoctools
, baloo
, kactivities
, kcmutils
, kcrash
, kdbusaddons
, kdeclarative
, kdelibs4support
, kdesu
, kdewebkit
, kglobalaccel
, kidletime
, kjsembed
, knewstuff
, knotifyconfig
, kpackage
, krunner
, ktexteditor
, ktextwidgets
, kwallet
, kwayland
, kwin
, kxmlrpcclient
, libdbusmenu
, libkscreen
, libSM
, libXcursor
, networkmanager-qt
, pam
, phonon
, plasma-framework
, qtscript
, qtx11extras
, wayland
, libksysguard
, bash
, coreutils
, gnused
, gnugrep
, socat
, kconfig
, kinit
, kservice
, qttools
, dbus
, mkfontdir
, xmessage
, xprop
, xrdb
, xset
, xsetroot
}:

plasmaPackage {
  name = "plasma-workspace";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    baloo
    kactivities
    kcmutils
    kcrash
    kdbusaddons
    kdeclarative
    kdelibs4support
    kdesu
    kdewebkit
    kglobalaccel
    kidletime
    kjsembed
    knewstuff
    knotifyconfig
    kpackage
    krunner
    ktexteditor
    ktextwidgets
    kwallet
    kwayland
    kwin
    kxmlrpcclient
    libdbusmenu
    libkscreen
    libSM
    libXcursor
    networkmanager-qt
    pam
    phonon
    plasma-framework
    qtscript
    qtx11extras
    wayland
  ];
  propagatedBuildInputs = [
    libksysguard
  ];
  patches = [ ./0001-startkde-NixOS-patches.patch ];

  inherit bash coreutils gnused gnugrep socat;
  inherit kconfig kinit kservice qttools;
  inherit mkfontdir xmessage xprop xrdb xset xsetroot;
  inherit (dbus) dbus-launch;
  postPatch = ''
    substituteAllInPlace startkde/startkde.cmake
    substituteInPlace startkde/kstartupconfig/kstartupconfig.cpp \
      --replace kdostartupconfig5 $out/bin/kdostartupconfig5
  '';
  postInstall = ''
    wrapKDEProgram "$out/bin/ksmserver"
    wrapKDEProgram "$out/bin/plasmawindowed"
    wrapKDEProgram "$out/bin/kcminit_startup"
    wrapKDEProgram "$out/bin/ksplashqml"
    wrapKDEProgram "$out/bin/kcheckrunning"
    wrapKDEProgram "$out/bin/systemmonitor"
    wrapKDEProgram "$out/bin/kstartupconfig5"
    wrapKDEProgram "$out/bin/startplasmacompositor"
    wrapKDEProgram "$out/bin/kdostartupconfig5"
    wrapKDEProgram "$out/bin/klipper"
    wrapKDEProgram "$out/bin/kuiserver5"
    wrapKDEProgram "$out/bin/krunner"
    wrapKDEProgram "$out/bin/plasmashell"
  '';
}

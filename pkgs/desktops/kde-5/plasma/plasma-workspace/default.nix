{ plasmaPackage, lib, copyPathsToStore
, extra-cmake-modules, kdoctools
, baloo, kactivities, kcmutils, kconfig, kcrash, kdbusaddons, kdeclarative
, kdelibs4support, kdesu, kglobalaccel, kidletime, kjsembed, knewstuff
, knotifyconfig, kpackage, krunner, ktexteditor, ktextwidgets, kwallet, kwayland
, kwin, kxmlrpcclient, libkscreen, libksysguard, networkmanager-qt, phonon
, plasma-framework, qtquickcontrols, qtscript, qtx11extras, solid
, isocodes, libdbusmenu, libSM, libXcursor, pam, wayland
}:

plasmaPackage {
  name = "plasma-workspace";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    baloo kactivities kcmutils kconfig kcrash kdbusaddons kdeclarative
    kdelibs4support kdesu kglobalaccel kidletime kjsembed knewstuff
    knotifyconfig kpackage krunner ktexteditor ktextwidgets kwallet kwayland
    kwin kxmlrpcclient libkscreen libksysguard networkmanager-qt phonon
    plasma-framework qtquickcontrols qtscript qtx11extras solid
    isocodes libdbusmenu libSM libXcursor pam wayland
  ];

  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);

  postPatch = ''
    substituteInPlace startkde/kstartupconfig/kstartupconfig.cpp \
        --replace kdostartupconfig5 $out/bin/kdostartupconfig5
  '';

  postInstall = ''
    rm "$out/bin/startkde"
    rm "$out/bin/startplasmacompositor"
    rm "$out/lib/libexec/startplasma"
    rm -r "$out/share/wayland-sessions"
  '';

  preFixup = ''
    wrapQtProgram $out/bin/kcheckrunning
    wrapQtProgram $out/bin/kcminit
    wrapQtProgram $out/bin/kcminit_startup
    wrapQtProgram $out/bin/kdostartupconfig5
    wrapQtProgram $out/bin/klipper
    wrapQtProgram $out/bin/krunner
    wrapQtProgram $out/bin/ksmserver
    wrapQtProgram $out/bin/ksplashqml
    wrapQtProgram $out/bin/kstartupconfig5
    wrapQtProgram $out/bin/kuiserver5
    wrapQtProgram $out/bin/plasmashell
    wrapQtProgram $out/bin/plasmawindowed
    wrapQtProgram $out/bin/systemmonitor
    wrapQtProgram $out/bin/xembedsniproxy
  '';
}

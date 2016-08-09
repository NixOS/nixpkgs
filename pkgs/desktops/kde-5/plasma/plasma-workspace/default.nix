{
  plasmaPackage, lib, copyPathsToStore,

  ecm, kdoctools,

  baloo, kactivities, kcmutils, kconfig, kcrash, kdbusaddons, kdeclarative,
  kdelibs4support, kdesu, kglobalaccel, kidletime, kjsembed, knewstuff,
  knotifyconfig, kpackage, krunner, ktexteditor, ktextwidgets, kwallet, kwayland,
  kwin, kxmlrpcclient, libkscreen, libksysguard, networkmanager-qt, phonon,
  plasma-framework, qtquickcontrols, qtscript, qtx11extras, solid, isocodes,
  libdbusmenu, libSM, libXcursor, pam, wayland
}:

plasmaPackage {
  name = "plasma-workspace";

  nativeBuildInputs = [ ecm kdoctools ];
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
}

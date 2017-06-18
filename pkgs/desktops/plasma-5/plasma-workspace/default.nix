{
  plasmaPackage, lib, copyPathsToStore,

  extra-cmake-modules, kdoctools,

  baloo, kactivities, kcmutils, kconfig, kcrash, kdbusaddons, kdeclarative,
  kdelibs4support, kdesu, kglobalaccel, kidletime, kjsembed, knewstuff,
  knotifyconfig, kpackage, krunner, ktexteditor, ktextwidgets, kwallet,
  kwayland, kwin, kxmlrpcclient, libkscreen, libksysguard, networkmanager-qt,
  phonon, plasma-framework, qtgraphicaleffects, qtquickcontrols,
  qtquickcontrols2, qtscript, qtx11extras, solid, isocodes, libdbusmenu, libSM,
  libXcursor, libXtst, pam, wayland
}:

plasmaPackage {
  name = "plasma-workspace";

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    isocodes libdbusmenu libSM libXcursor libXtst pam wayland
  ];
  propagatedBuildInputs = [
    baloo kactivities kcmutils kconfig kcrash kdbusaddons kdeclarative
    kdelibs4support kdesu kglobalaccel kidletime kjsembed knewstuff
    knotifyconfig kpackage krunner ktexteditor ktextwidgets kwallet kwayland
    kwin kxmlrpcclient libkscreen libksysguard networkmanager-qt phonon
    plasma-framework solid qtgraphicaleffects qtquickcontrols qtquickcontrols2
    qtscript qtx11extras
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

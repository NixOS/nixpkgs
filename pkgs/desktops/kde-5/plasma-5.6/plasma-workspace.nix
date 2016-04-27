{ plasmaPackage, lib
, extra-cmake-modules, kdoctools
, baloo, kactivities, kcmutils, kconfig, kcrash, kdbusaddons, kdeclarative
, kdelibs4support, kdesu, kdewebkit, kglobalaccel, kidletime, kjsembed, knewstuff
, knotifyconfig, kpackage, krunner, ktexteditor, ktextwidgets, kwallet, kwayland
, kwin, kxmlrpcclient, libdbusmenu, libkscreen, libksysguard, libSM, libXcursor
, networkmanager-qt, pam, phonon, plasma-framework, qtquick1, qtquickcontrols
, qtscript, qtx11extras, solid, wayland
}:

plasmaPackage {
  name = "plasma-workspace";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    baloo kactivities kcmutils kconfig kcrash kdbusaddons kdeclarative
    kdelibs4support kdesu kdewebkit kglobalaccel kidletime kjsembed knewstuff
    knotifyconfig kpackage krunner ktexteditor ktextwidgets kwallet kwayland
    kwin kxmlrpcclient libdbusmenu libkscreen libksysguard libSM libXcursor
    networkmanager-qt pam phonon plasma-framework qtquick1 qtquickcontrols
    qtscript qtx11extras solid wayland
  ];

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

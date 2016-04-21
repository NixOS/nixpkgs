{ plasmaPackage, lib
, extra-cmake-modules, kdoctools
, baloo, kactivities, kcmutils, kcrash, kdbusaddons, kdeclarative
, kdelibs4support, kdesu, kdewebkit, kglobalaccel, kidletime
, kjsembed, knewstuff, knotifyconfig, kpackage, krunner
, ktexteditor, ktextwidgets, kwallet, kwayland, kwin, kxmlrpcclient
, libdbusmenu, libkscreen, libSM, libXcursor, networkmanager-qt
, pam, phonon, plasma-framework, qtquick1, qtscript, qtx11extras, wayland
, libksysguard, kconfig, solid, qtquickcontrols
}:

plasmaPackage {
  name = "plasma-workspace";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcmutils kconfig kcrash kdbusaddons kdesu kdewebkit
    kjsembed knewstuff knotifyconfig kpackage
    ktextwidgets kwallet kwayland kxmlrpcclient libdbusmenu libSM
    libXcursor networkmanager-qt pam phonon qtscript
    wayland
  ];
  propagatedBuildInputs = [
    baloo kactivities kdeclarative kdelibs4support kglobalaccel
    kidletime krunner ktexteditor kwin libkscreen libksysguard
    plasma-framework qtquick1 qtquickcontrols qtx11extras solid
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

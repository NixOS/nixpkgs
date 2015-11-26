{ plasmaPackage, extra-cmake-modules, kdoctools, baloo
, kactivities, kcmutils, kcrash, kdbusaddons, kdeclarative
, kdelibs4support, kdesu, kdewebkit, kglobalaccel, kidletime
, kjsembed, knewstuff, knotifyconfig, kpackage, krunner
, ktexteditor, ktextwidgets, kwallet, kwayland, kwin, kxmlrpcclient
, libdbusmenu, libkscreen, libSM, libXcursor, networkmanager-qt
, pam, phonon, plasma-framework, qtquick1, qtscript, qtx11extras, wayland
, libksysguard, bash, coreutils, gnused, gnugrep, socat, kconfig
, kinit, kservice, makeQtWrapper, qttools, dbus_tools, mkfontdir, xmessage
, xprop, xrdb, xset, xsetroot, solid, qtquickcontrols
}:

plasmaPackage rec {
  name = "plasma-workspace";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  buildInputs = [
    kcmutils kcrash kdbusaddons kdesu kdewebkit kjsembed knewstuff
    knotifyconfig kpackage ktextwidgets kwallet kwayland kxmlrpcclient
    libdbusmenu libSM libXcursor networkmanager-qt pam phonon
    qtscript wayland
  ];
  propagatedBuildInputs = [
    baloo kactivities kdeclarative kdelibs4support kglobalaccel
    kidletime krunner ktexteditor kwin libkscreen libksysguard
    plasma-framework qtquick1 qtquickcontrols qtx11extras solid
  ];
  patches = [ ./0001-startkde-NixOS-patches.patch ];

  inherit bash coreutils gnused gnugrep socat;
  inherit kconfig kinit kservice qttools;
  inherit dbus_tools mkfontdir xmessage xprop xrdb xset xsetroot;
  postPatch = ''
    substituteAllInPlace startkde/startkde.cmake
    substituteInPlace startkde/kstartupconfig/kstartupconfig.cpp \
      --replace kdostartupconfig5 $out/bin/kdostartupconfig5
  '';
  postInstall = ''
    wrapQtProgram "$out/bin/ksmserver"
    wrapQtProgram "$out/bin/plasmawindowed"
    wrapQtProgram "$out/bin/kcminit_startup"
    wrapQtProgram "$out/bin/ksplashqml"
    wrapQtProgram "$out/bin/kcheckrunning"
    wrapQtProgram "$out/bin/systemmonitor"
    wrapQtProgram "$out/bin/kstartupconfig5"
    wrapQtProgram "$out/bin/startplasmacompositor"
    wrapQtProgram "$out/bin/kdostartupconfig5"
    wrapQtProgram "$out/bin/klipper"
    wrapQtProgram "$out/bin/kuiserver5"
    wrapQtProgram "$out/bin/krunner"
    wrapQtProgram "$out/bin/plasmashell"
  '';
}

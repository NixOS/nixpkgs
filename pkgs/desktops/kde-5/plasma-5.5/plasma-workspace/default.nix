{ plasmaPackage, lib, copyPathsToStore
, extra-cmake-modules, kdoctools, makeQtWrapper
, baloo, kactivities, kcmutils, kcrash, kdbusaddons, kdeclarative
, kdelibs4support, kdesu, kdewebkit, kglobalaccel, kidletime
, kjsembed, knewstuff, knotifyconfig, kpackage, krunner
, ktexteditor, ktextwidgets, kwallet, kwayland, kwin, kxmlrpcclient
, libdbusmenu, libkscreen, libSM, libXcursor, networkmanager-qt
, pam, phonon, plasma-framework, qtquick1, qtscript, qtx11extras, wayland
, libksysguard, bash, coreutils, gnused, gnugrep, socat, kconfig
, kinit, kservice, qttools, dbus_tools, mkfontdir, xmessage
, xprop, xrdb, xset, xsetroot, solid, qtquickcontrols
}:

plasmaPackage {
  name = "plasma-workspace";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  buildInputs = [
    dbus_tools kcmutils kconfig kcrash kdbusaddons kdesu kdewebkit
    kinit kjsembed knewstuff knotifyconfig kpackage kservice
    ktextwidgets kwallet kwayland kxmlrpcclient libdbusmenu libSM
    libXcursor mkfontdir networkmanager-qt pam phonon qtscript qttools
    socat wayland xmessage xprop xset xsetroot
  ];
  propagatedBuildInputs = [
    baloo kactivities kdeclarative kdelibs4support kglobalaccel
    kidletime krunner ktexteditor kwin libkscreen libksysguard
    plasma-framework qtquick1 qtquickcontrols qtx11extras solid
  ];

  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);

  postPatch = ''
    substituteInPlace startkde/startkde.cmake \
        --subst-var-by bash $(type -P bash) \
        --subst-var-by sed $(type -P sed) \
        --subst-var-by grep $(type -P grep) \
        --subst-var-by socat $(type -P socat) \
        --subst-var-by kcheckrunning $(type -P kcheckrunning) \
        --subst-var-by xmessage $(type -P xmessage) \
        --subst-var-by tr $(type -P tr) \
        --subst-var-by qtpaths $(type -P qtpaths) \
        --subst-var-by qdbus $(type -P qdbus) \
        --subst-var-by dbus-launch $(type -P dbus-launch) \
        --subst-var-by mkfontdir $(type -P mkfontdir) \
        --subst-var-by xset $(type -P xset) \
        --subst-var-by xsetroot $(type -P xsetroot) \
        --subst-var-by xprop $(type -P xprop) \
        --subst-var-by start_kdeinit_wrapper "${kinit.out}/lib/libexec/kf5/start_kdeinit_wrapper" \
        --subst-var-by kwrapper5 $(type -P kwrapper5) \
        --subst-var-by kdeinit5_shutdown $(type -P kdeinit5_shutdown) \
        --subst-var-by kbuildsycoca5 $(type -P kbuildsycoca5) \
        --subst-var-by kreadconfig5 $(type -P kreadconfig5) \
        --subst-var out
    substituteInPlace startkde/kstartupconfig/kstartupconfig.cpp \
        --replace kdostartupconfig5 $out/bin/kdostartupconfig5
  '';

  postInstall = ''
    rm "$out/bin/startplasmacompositor"
    rm "$out/lib/libexec/startplasma"
    rm -r "$out/share/wayland-sessions"
  '';
}

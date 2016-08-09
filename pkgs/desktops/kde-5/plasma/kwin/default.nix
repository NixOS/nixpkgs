{
  plasmaPackage, lib, copyPathsToStore,
  ecm, kdoctools,
  breeze-qt5, epoxy, kactivities, kcompletion, kcmutils, kconfig,
  kconfigwidgets, kcoreaddons, kcrash, kdeclarative, kdecoration, kglobalaccel,
  ki18n, kiconthemes, kidletime, kinit, kio, knewstuff, knotifications,
  kpackage, kscreenlocker, kservice, kwayland, kwidgetsaddons, kwindowsystem,
  kxmlgui, libinput, libICE, libSM, plasma-framework, qtdeclarative,
  qtmultimedia, qtscript, qtx11extras, udev, wayland, xcb-util-cursor, xwayland
}:

plasmaPackage {
  name = "kwin";
  nativeBuildInputs = [
    ecm
    kdoctools
  ];
  propagatedBuildInputs = [
    breeze-qt5 epoxy kactivities kcmutils kcompletion kconfig kconfigwidgets
    kcoreaddons kcrash kdeclarative kdecoration kglobalaccel ki18n kiconthemes
    kidletime kinit kio knewstuff knotifications kpackage kscreenlocker kservice
    kwayland kwidgetsaddons kwindowsystem kxmlgui libinput libICE libSM
    plasma-framework qtdeclarative qtmultimedia qtscript qtx11extras udev
    wayland xcb-util-cursor
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  postPatch = ''
    substituteInPlace main_wayland.cpp \
        --subst-var-by xwayland ${lib.getBin xwayland}/bin/Xwayland
  '';
  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=OFF" ];
}

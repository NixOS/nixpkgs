{ plasmaPackage, extra-cmake-modules, kdoctools, epoxy
, kactivities, kcompletion, kcmutils, kconfig, kconfigwidgets
, kcoreaddons, kcrash, kdeclarative, kdecoration, kglobalaccel
, ki18n, kiconthemes, kinit, kio, knewstuff, knotifications
, kpackage, kservice, kwayland, kwidgetsaddons, kwindowsystem
, kxmlgui, libinput, libICE, libSM, plasma-framework, qtdeclarative
, qtmultimedia, qtscript, qtx11extras, udev, wayland, xcb-util-cursor
, makeQtWrapper
}:

plasmaPackage {
  name = "kwin";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  buildInputs = [
    epoxy kcompletion kcmutils kconfig kconfigwidgets kcoreaddons
    kcrash kdecoration kiconthemes kinit knewstuff knotifications
    kpackage kservice kwayland kwidgetsaddons kxmlgui libinput libICE
    libSM qtscript udev wayland xcb-util-cursor
  ];
  propagatedBuildInputs = [
    kactivities kdeclarative kglobalaccel ki18n kio kwindowsystem
    plasma-framework qtdeclarative qtmultimedia qtx11extras
  ];
  patches = [ ./0001-qdiriterator-follow-symlinks.patch ];
  postInstall = ''
    wrapQtProgram "$out/bin/kwin_x11"
    wrapQtProgram "$out/bin/kwin_wayland"
  '';
}

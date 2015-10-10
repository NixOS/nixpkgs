{ plasmaPackage, extra-cmake-modules, kdoctools, epoxy
, kactivities, kcompletion, kcmutils, kconfig, kconfigwidgets
, kcoreaddons, kcrash, kdeclarative, kdecoration, kglobalaccel
, ki18n, kiconthemes, kinit, kio, knewstuff, knotifications
, kpackage, kservice, kwayland, kwidgetsaddons, kwindowsystem
, kxmlgui, libinput, libICE, libSM, plasma-framework, qtdeclarative
, qtscript, qtx11extras, udev, wayland, xcb-util-cursor
}:

plasmaPackage {
  name = "kwin";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    epoxy kcompletion kcmutils kconfig kconfigwidgets kcoreaddons
    kcrash kdecoration kiconthemes kinit knewstuff knotifications
    kpackage kservice kwayland kwidgetsaddons kxmlgui libinput libICE
    libSM qtscript udev wayland xcb-util-cursor
  ];
  propagatedBuildInputs = [
    kactivities kdeclarative kglobalaccel ki18n kio kwindowsystem
    plasma-framework qtdeclarative qtx11extras
  ];
  patches = [ ./kwin-import-plugin-follow-symlinks.patch ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kwin_x11"
    wrapKDEProgram "$out/bin/kwin_wayland"
  '';
}

{ plasmaPackage, extra-cmake-modules, kdoctools, epoxy
, kactivities, kcompletion, kcmutils, kconfig, kconfigwidgets
, kcoreaddons, kcrash, kdeclarative, kdecoration, kglobalaccel
, ki18n, kiconthemes, kidletime, kinit, kio, knewstuff, knotifications
, kpackage, kscreenlocker, kservice, kwayland, kwidgetsaddons, kwindowsystem
, kxmlgui, libinput, libICE, libSM, plasma-framework, qtdeclarative
, qtmultimedia, qtscript, qtx11extras, udev, wayland, xcb-util-cursor
, makeQtWrapper, qtwayland, xwayland
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
    kcrash kdecoration kiconthemes kidletime kinit knewstuff knotifications
    kpackage kservice kwayland kwidgetsaddons kxmlgui libinput libICE
    libSM qtscript udev wayland xcb-util-cursor qtwayland xwayland
  ];
  propagatedBuildInputs = [
    kactivities kdeclarative kglobalaccel ki18n kio kscreenlocker
    kwindowsystem plasma-framework qtdeclarative qtmultimedia qtx11extras
  ];
  patches = [ ./0001-qdiriterator-follow-symlinks.patch ./0002_permissive_application_path.patch ];
  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=OFF" ];
  postInstall = ''
    wrapQtProgram "$out/bin/kwin_x11"
    wrapQtProgram "$out/bin/kwin_wayland"
  '';
}

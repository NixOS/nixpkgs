{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules, kdoctools,

  epoxy, lcms2, libICE, libSM, libcap, libdrm, libinput, libxkbcommon, mesa,
  pipewire, udev, wayland, xcb-util-cursor, xwayland,

  qtdeclarative, qtmultimedia, qtquickcontrols2, qtscript, qtsensors,
  qtvirtualkeyboard, qtx11extras,

  breeze-qt5, kactivities, kcompletion, kcmutils, kconfig, kconfigwidgets,
  kcoreaddons, kcrash, kdeclarative, kdecoration, kglobalaccel, ki18n,
  kiconthemes, kidletime, kinit, kio, knewstuff, knotifications, kpackage,
  krunner, kscreenlocker, kservice, kwayland, kwayland-server, kwidgetsaddons,
  kwindowsystem, kxmlgui, plasma-framework,
}:

# TODO (ttuegel): investigate qmlplugindump failure

mkDerivation {
  name = "kwin";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    epoxy lcms2 libICE libSM libcap libdrm libinput libxkbcommon mesa pipewire
    udev wayland xcb-util-cursor xwayland

    qtdeclarative qtmultimedia qtquickcontrols2 qtscript qtsensors
    qtvirtualkeyboard qtx11extras

    breeze-qt5 kactivities kcmutils kcompletion kconfig kconfigwidgets
    kcoreaddons kcrash kdeclarative kdecoration kglobalaccel ki18n kiconthemes
    kidletime kinit kio knewstuff knotifications kpackage krunner kscreenlocker
    kservice kwayland kwayland-server kwidgetsaddons kwindowsystem kxmlgui
    plasma-framework

  ];
  outputs = [ "dev" "out" ];
  patches = [
    ./0001-follow-symlinks.patch
    ./0002-xwayland.patch
    ./0003-plugins-qpa-allow-using-nixos-wrapper.patch
    ./0001-NixOS-Unwrap-executable-name-for-.desktop-search.patch
    # Fix build against libglvnd 1.3.4+
    # Remove with release 5.22.90
    (fetchpatch {
      url = "https://invent.kde.org/plasma/kwin/-/commit/839710201c389b7f4ed248cb3818e755a37ce977.patch";
      sha256 = "09rldhy0sbmqdfpyjzwm20cwnmrmj0w2751vyi5xlr414g0rzyc1";
    })
    # Fixup previous patch for i686
    # Remove with release 5.22.90
    (fetchpatch {
      url = "https://invent.kde.org/plasma/kwin/-/commit/38e24ecd6416a975db0989c21b70d6a4cc242f35.patch";
      sha256 = "0zsjmzswcnvfd2jm1c8i9aijpbap1141mjv6y4j282bplyqlp966";
    })
  ];
  CXXFLAGS = [
    ''-DNIXPKGS_XWAYLAND=\"${lib.getBin xwayland}/bin/Xwayland\"''
  ];
  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=OFF" ];
  postInstall = ''
    # Some package(s) refer to these service types by the wrong name.
    # I would prefer to patch those packages, but I cannot find them!
    ln -s ''${!outputBin}/share/kservicetypes5/kwineffect.desktop \
          ''${!outputBin}/share/kservicetypes5/kwin-effect.desktop
    ln -s ''${!outputBin}/share/kservicetypes5/kwinscript.desktop \
          ''${!outputBin}/share/kservicetypes5/kwin-script.desktop
  '';
}

{
  mkDerivation, lib, copyPathsToStore, fetchpatch,
  extra-cmake-modules, kdoctools,

  epoxy,libICE, libSM, libinput, libxkbcommon, udev, wayland, xcb-util-cursor,
  xwayland,

  qtdeclarative, qtmultimedia, qtscript, qtx11extras,

  breeze-qt5, kactivities, kcompletion, kcmutils, kconfig, kconfigwidgets,
  kcoreaddons, kcrash, kdeclarative, kdecoration, kglobalaccel, ki18n,
  kiconthemes, kidletime, kinit, kio, knewstuff, knotifications, kpackage,
  kscreenlocker, kservice, kwayland, kwidgetsaddons, kwindowsystem, kxmlgui,
  plasma-framework, qtsensors, libcap
}:

mkDerivation {
  name = "kwin";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    epoxy libICE libSM libinput libxkbcommon udev wayland xcb-util-cursor
    xwayland

    qtdeclarative qtmultimedia qtscript qtx11extras qtsensors

    breeze-qt5 kactivities kcmutils kcompletion kconfig kconfigwidgets
    kcoreaddons kcrash kdeclarative kdecoration kglobalaccel ki18n kiconthemes
    kidletime kinit kio knewstuff knotifications kpackage kscreenlocker kservice
    kwayland kwidgetsaddons kwindowsystem kxmlgui plasma-framework
    libcap
  ];
  outputs = [ "bin" "dev" "out" ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series) ++ [
    # This patch should be removed in 5.12.2
    (fetchpatch {
      url = "https://github.com/KDE/kwin/commit/6e5f5d92daab4c60f7bf241d90a91b3bea27acfd.patch";
      sha256 = "1yq9wjvch46z7qx051s0ws0gyqbqhkvx7xl4pymd97vz8v6gnx4x";
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

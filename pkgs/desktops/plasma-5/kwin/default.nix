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
  plasma-framework,
}:

mkDerivation {
  name = "kwin";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    epoxy libICE libSM libinput libxkbcommon udev wayland xcb-util-cursor
    xwayland

    qtdeclarative qtmultimedia qtscript qtx11extras

    breeze-qt5 kactivities kcmutils kcompletion kconfig kconfigwidgets
    kcoreaddons kcrash kdeclarative kdecoration kglobalaccel ki18n kiconthemes
    kidletime kinit kio knewstuff knotifications kpackage kscreenlocker kservice
    kwayland kwidgetsaddons kwindowsystem kxmlgui plasma-framework
  ];
  outputs = [ "bin" "dev" "out" ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series)
    ++ [(fetchpatch {
        name = "cmake-3.10.diff";
        # included upstream for kwin >= 5.11.95
        url = "https://github.com/KDE/kwin/commit/cd544890ced4192.diff";
        sha256 = "0z5nbcg712v10mskb7r9v0jcx5h8q4ixb7fjbb0kicmzsc266yd5";
    })]
    ;
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

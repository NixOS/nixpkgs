{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,

  epoxy,libICE, libSM, libinput, libxkbcommon, udev, wayland, xcb-util-cursor,
  xwayland,

  qtdeclarative, qtmultimedia, qtquickcontrols2, qtscript, qtsensors,
  qtvirtualkeyboard, qtx11extras,

  breeze-qt5, kactivities, kcompletion, kcmutils, kconfig, kconfigwidgets,
  kcoreaddons, kcrash, kdeclarative, kdecoration, kglobalaccel, ki18n,
  kiconthemes, kidletime, kinit, kio, knewstuff, knotifications, kpackage,
  kscreenlocker, kservice, kwayland, kwidgetsaddons, kwindowsystem, kxmlgui,
  plasma-framework, libcap, libdrm, mesa,
  
  lowLatencyPatch ? true, fetchpatch ? null
}:

# TODO (ttuegel): investigate qmlplugindump failure

mkDerivation {
  name = "kwin";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    epoxy libICE libSM libinput libxkbcommon udev wayland xcb-util-cursor
    xwayland

    qtdeclarative qtmultimedia qtquickcontrols2 qtscript qtsensors
    qtvirtualkeyboard qtx11extras

    breeze-qt5 kactivities kcmutils kcompletion kconfig kconfigwidgets
    kcoreaddons kcrash kdeclarative kdecoration kglobalaccel ki18n kiconthemes
    kidletime kinit kio knewstuff knotifications kpackage kscreenlocker kservice
    kwayland kwidgetsaddons kwindowsystem kxmlgui plasma-framework
    libcap libdrm mesa
  ];
  outputs = [ "bin" "dev" "out" ];
  patches = [
    ./0001-follow-symlinks.patch
    ./0002-xwayland.patch
  ]++ lib.optional lowLatencyPatch (fetchpatch {
    # WARNING: we can't depend the url on the version 
    # so we must update this url+hash on plasma version update as described in
    # "https://github.com/tildearrow/kwin-lowlatency#patch-format (branch depending on the Plasma version)
    url = "https://tildearrow.zapto.org/storage/kwin-lowlatency/kwin-lowlatency-5.18.5-3.patch";
    hash = "sha256-YsCgQxWduEpzUVMme0D4QQAEdSRs1+tiLEiZQVNgE00=";
  });
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

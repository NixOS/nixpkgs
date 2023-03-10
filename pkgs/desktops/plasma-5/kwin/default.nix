{ mkDerivation
, stdenv
, lib
, extra-cmake-modules
, kdoctools
, fetchpatch
, libepoxy
, lcms2
, libICE
, libSM
, libcap
, libdrm
, libinput
, libxkbcommon
, mesa
, pipewire
, udev
, wayland
, xcb-util-cursor
, xwayland
, plasma-wayland-protocols
, wayland-protocols
, libxcvt
, qtdeclarative
, qtmultimedia
, qtquickcontrols2
, qtscript
, qtsensors
, qtvirtualkeyboard
, qtx11extras
, breeze-qt5
, kactivities
, kcompletion
, kcmutils
, kconfig
, kconfigwidgets
, kcoreaddons
, kcrash
, kdeclarative
, kdecoration
, kglobalaccel
, ki18n
, kiconthemes
, kidletime
, kinit
, kio
, knewstuff
, knotifications
, kpackage
, krunner
, kscreenlocker
, kservice
, kwayland
, kwidgetsaddons
, kwindowsystem
, kxmlgui
, plasma-framework
, libqaccessibilityclient
, python3
, gcc12Stdenv
}:

# TODO (ttuegel): investigate qmlplugindump failure

mkDerivation {
  pname = "kwin";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    libepoxy
    lcms2
    libICE
    libSM
    libcap
    libdrm
    libinput
    libxkbcommon
    mesa
    pipewire
    udev
    wayland
    xcb-util-cursor
    xwayland
    libxcvt
    plasma-wayland-protocols
    wayland-protocols

    qtdeclarative
    qtmultimedia
    qtquickcontrols2
    qtscript
    qtsensors
    qtvirtualkeyboard
    qtx11extras

    breeze-qt5
    kactivities
    kcmutils
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdeclarative
    kdecoration
    kglobalaccel
    ki18n
    kiconthemes
    kidletime
    kinit
    kio
    knewstuff
    knotifications
    kpackage
    krunner
    kscreenlocker
    kservice
    kwayland
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    plasma-framework
    libqaccessibilityclient

  ];
  outputs = [ "out" "dev" ];

  postPatch = ''
    patchShebangs src/effects/strip-effect-metadata.py
  '';

  patches = [
    ./0001-follow-symlinks.patch
    ./0002-xwayland.patch
    ./0003-plugins-qpa-allow-using-nixos-wrapper.patch
    ./0001-NixOS-Unwrap-executable-name-for-.desktop-search.patch
    ./0001-Lower-CAP_SYS_NICE-from-the-ambient-set.patch
    # Pass special environments through arguemnts to `kwin_wayland`, bypassing
    # ld.so(8) environment stripping due to `kwin_wayland`'s capabilities.
    # We need this to have `TZDIR` correctly set for `plasmashell`, or
    # everything related to timezone, like clock widgets, will be broken.
    # https://invent.kde.org/plasma/kwin/-/merge_requests/1590
    (fetchpatch {
      url = "https://invent.kde.org/plasma/kwin/-/commit/9a008b223ad696db3bf5692750f2b74e578e08b8.diff";
      sha256 = "sha256-f35G+g2MVABLDbAkCed3ZmtDWrzYn1rdD08mEx35j4k=";
    })
  ];

  stdenv = if stdenv.isAarch64 then gcc12Stdenv else stdenv;

  CXXFLAGS = [
    ''-DNIXPKGS_XWAYLAND=\"${lib.getBin xwayland}/bin/Xwayland\"''
  ]
  ++ lib.optional stdenv.isAarch64 "-mno-outline-atomics";

  postInstall = ''
    # Some package(s) refer to these service types by the wrong name.
    # I would prefer to patch those packages, but I cannot find them!
    ln -s ''${!outputBin}/share/kservicetypes5/kwineffect.desktop \
          ''${!outputBin}/share/kservicetypes5/kwin-effect.desktop
    ln -s ''${!outputBin}/share/kservicetypes5/kwinscript.desktop \
          ''${!outputBin}/share/kservicetypes5/kwin-script.desktop
  '';
}

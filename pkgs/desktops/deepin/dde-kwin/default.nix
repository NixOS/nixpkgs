{ stdenv
, mkDerivation
, pkgconfig
, fetchFromGitHub
, deepin
, cmake
, extra-cmake-modules
, qtbase
, libxcb
, kglobalaccel
, kwindowsystem
, kcoreaddons
, kwin
, dtkcore
, gsettings-qt
, fontconfig
, deepin-desktop-schemas
, glib
, libXrender
, mtdev
, qttools
, deepin-gettext-tools
, kwayland
, qtx11extras
, qtquickcontrols2
, epoxy
, qt5integration
, dde-session-ui
, dbus
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "dde-kwin";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0bvkx9h5ygj46a0j76kfyq3gvk6zn4fx6clhrmcr40hbi2k33cbl";
  };

  nativeBuildInputs = [
    cmake
    deepin-gettext-tools
    deepin.setupHook
    extra-cmake-modules
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    deepin-desktop-schemas
    dtkcore
    epoxy
    fontconfig
    glib
    gsettings-qt
    kcoreaddons
    kglobalaccel
    kwayland
    kwin
    kwindowsystem
    libXrender
    libxcb
    mtdev
    qtbase
    qtquickcontrols2
    qttools
    qtx11extras
    qt5integration
  ];

  # Need to add kwayland around:
  # * https://github.com/linuxdeepin/dde-kwin/blob/5226bb984c844129f9fa589da56e77decb7b39a1/plugins/kwineffects/blur/CMakeLists.txt#L14
  NIX_CFLAGS_COMPILE = [
    "-I${kwayland.dev}/include/KF5"
  ];

  cmakeFlags = [
    "-DKWIN_VERSION=${(builtins.parseDrvName kwin.name).version}"
  ];

  patches = [
    ./0001-dde-kwin.pc-make-paths-relative.patch
    ./fix-paths.patch
  ];

  postPatch = ''
    searchHardCodedPaths

    patchShebangs translate_ts2desktop.sh \
      translate_generation.sh \
      translate_desktop2ts.sh \
      plugins/kwin-xcb/plugin/translate_generation.sh

    fixPath ${deepin-gettext-tools} /usr/bin/deepin-desktop-ts-convert translate_desktop2ts.sh translate_ts2desktop.sh

    fixPath $out /etc/xdg configures/CMakeLists.txt deepin-wm-dbus/deepinwmfaker.cpp

    # TODO: Need environmental patch
    fixPath /run/current-system/sw /usr/lib plugins/kwin-xcb/plugin/main.cpp

    substituteInPlace configures/kwin-wm-multitaskingview.desktop \
      --replace "dbus-send" "${dbus}/bin/dbus-send"

    fixPath ${dde-session-ui} /usr/lib/deepin-daemon/dde-warning-dialog deepin-wm-dbus/deepinwmfaker.cpp

    # Correct qt plugin installation path to be within dde-kwin prefix.
    substituteInPlace CMakeLists.txt \
      --subst-var-by plugin_path "$out/$qtPluginPrefix"
  '';

  postInstall = ''
    # Correct invalid path in .pc
    substituteInPlace $out/lib/pkgconfig/dde-kwin.pc \
      --replace "-L/usr/X11R6/lib64" ""

    chmod +x $out/bin/kwin_no_scale
  '';

  dontWrapQtApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
    )
  '';

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "KWin configuration for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/dde-kwin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo worldofpeace ];
  };
}

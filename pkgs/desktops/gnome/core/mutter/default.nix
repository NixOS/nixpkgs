{ fetchurl
, runCommand
, lib
, stdenv
, pkg-config
, gnome
, gettext
, gobject-introspection
, cairo
, colord
, lcms2
, pango
, libstartup_notification
, libcanberra
, ninja
, xvfb-run
, libxcvt
, libICE
, libX11
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXtst
, libxkbfile
, xkeyboard_config
, libxkbcommon
, libXrender
, libxcb
, libXrandr
, libXinerama
, libXau
, libinput
, libdrm
, libei
, libdisplay-info
, gsettings-desktop-schemas
, glib
, atk
, gtk4
, fribidi
, harfbuzz
, gnome-desktop
, pipewire
, libgudev
, libwacom
, libSM
, xwayland
, mesa
, meson
, gnome-settings-daemon
, xorgserver
, python3
, wrapGAppsHook4
, gi-docgen
, sysprof
, libsysprof-capture
, desktop-file-utils
, egl-wayland
, graphene
, wayland
, wayland-protocols
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mutter";
  version = "46.4";

  outputs = [ "out" "dev" "man" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${lib.versions.major finalAttrs.version}/mutter-${finalAttrs.version}.tar.xz";
    hash = "sha256-YRvZz5gq21ZZfOKzQiQnL9phm7O7kSpoTXXG8sN1AuQ=";
  };

  mesonFlags = [
    "-Degl_device=true"
    "-Dinstalled_tests=false" # TODO: enable these
    "-Dtests=false"
    "-Dwayland_eglstream=true"
    "-Dprofiler=true"
    "-Dxwayland_path=${lib.getExe xwayland}"
    # This should be auto detected, but it looks like it manages a false
    # positive.
    "-Dxwayland_initfd=disabled"
    "-Ddocs=true"
  ];

  propagatedBuildInputs = [
    # required for pkg-config to detect mutter-mtk
    graphene
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxcvt
    mesa # needed for gbm
    meson
    ninja
    xvfb-run
    pkg-config
    python3
    wrapGAppsHook4
    gi-docgen
    xorgserver
    gobject-introspection
  ];

  buildInputs = [
    cairo
    egl-wayland
    glib
    gnome-desktop
    gnome-settings-daemon
    gsettings-desktop-schemas
    atk
    fribidi
    harfbuzz
    libcanberra
    libdrm
    libei
    libdisplay-info
    libgudev
    libinput
    libstartup_notification
    libwacom
    libSM
    colord
    lcms2
    pango
    pipewire
    sysprof # for D-Bus interfaces
    libsysprof-capture
    xwayland
    wayland
    wayland-protocols
  ] ++ [
    # X11 client
    gtk4
    libICE
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXtst
    libxkbfile
    xkeyboard_config
    libxkbcommon
    libXrender
    libxcb
    libXrandr
    libXinerama
    libXau
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    # TODO: Move this into a directory devhelp can find.
    moveToOutput "share/mutter-14/doc" "$devdoc"
  '';

  # Install udev files into our own tree.
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  separateDebugInfo = true;

  passthru = {
    libdir = "${finalAttrs.finalPackage}/lib/mutter-14";

    tests = {
      libdirExists = runCommand "mutter-libdir-exists" {} ''
        if [[ ! -d ${finalAttrs.finalPackage.libdir} ]]; then
          echo "passthru.libdir should contain a directory, “${finalAttrs.finalPackage.libdir}” is not one."
          exit 1
        fi
        touch $out
      '';
    };

    updateScript = gnome.updateScript {
      packageName = "mutter";
      attrPath = "gnome.mutter";
    };
  };

  meta = with lib; {
    description = "Window manager for GNOME";
    mainProgram = "mutter";
    homepage = "https://gitlab.gnome.org/GNOME/mutter";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})

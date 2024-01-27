{ fetchurl
, runCommand
, lib
, fetchpatch
, stdenv
, pkg-config
, gnome
, gettext
, gobject-introspection
, cairo
, colord
, lcms2
, pango
, json-glib
, libstartup_notification
, libcanberra
, ninja
, xvfb-run
, xkeyboard_config
, libxcvt
, libxkbfile
, libXdamage
, libxkbcommon
, libXtst
, libinput
, libdrm
, gsettings-desktop-schemas
, glib
, gtk3
, gnome-desktop
, pipewire
, libgudev
, libwacom
, xwayland
, mesa
, meson
, gnome-settings-daemon
, xorgserver
, python3
, wrapGAppsHook
, gi-docgen
, sysprof
, libsysprof-capture
, desktop-file-utils
, libcap_ng
, egl-wayland
, graphene
, wayland
, wayland-protocols
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mutter";
  version = "43.8";

  outputs = [ "out" "dev" "man" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${lib.versions.major finalAttrs.version}/mutter-${finalAttrs.version}.tar.xz";
    sha256 = "TjTh8XWTS9hJqEvZX6Nb8G6EEuAt8loDbC8RNdUz8oE=";
  };

  patches = [
    # Fix build with separate sysprof.
    # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2572
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/285a5a4d54ca83b136b787ce5ebf1d774f9499d5.patch";
      sha256 = "/npUE3idMSTVlFptsDpZmGWjZ/d2gqruVlJKq4eF4xU=";
    })

    # Remove support for window shading.
    # The corresponding key was removed in gsettings-desktop-schemas 45.alpha.
    # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2884
    #
    # Fetch the patch from magpie as they share same code base and this feature
    # is never supported on wayland (note that magpie 0.9.x won't support wayland).
    # https://github.com/BuddiesOfBudgie/magpie/issues/9
    (fetchpatch {
      url = "https://github.com/BuddiesOfBudgie/magpie/commit/4177c466375462ca8ed8fdb60913df4422f19144.patch";
      sha256 = "NVx40WDnlUL050D529KVohvNBdVrheXxmJ73U3+KSeQ=";
    })
  ];

  mesonFlags = [
    "-Degl_device=true"
    "-Dinstalled_tests=false" # TODO: enable these
    "-Dwayland_eglstream=true"
    "-Dprofiler=true"
    "-Dxwayland_path=${lib.getExe xwayland}"
    # This should be auto detected, but it looks like it manages a false
    # positive.
    "-Dxwayland_initfd=disabled"
    "-Ddocs=true"
  ];

  propagatedBuildInputs = [
    # required for pkg-config to detect mutter-clutter
    json-glib
    libXtst
    libcap_ng
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
    wrapGAppsHook
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
    gtk3
    libcanberra
    libdrm
    libgudev
    libinput
    libstartup_notification
    libwacom
    libxkbcommon
    libxkbfile
    libXdamage
    colord
    lcms2
    pango
    pipewire
    sysprof # for D-Bus interfaces
    libsysprof-capture
    xkeyboard_config
    xwayland
    wayland
    wayland-protocols
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py

    # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3187
    substituteInPlace meson.build \
      --replace "dependency('sysprof-4')" "dependency('sysprof-6')"
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    # TODO: Move this into a directory devhelp can find.
    moveToOutput "share/mutter-11/doc" "$devdoc"
  '';

  # Install udev files into our own tree.
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  separateDebugInfo = true;

  passthru = {
    libdir = "${finalAttrs.finalPackage}/lib/mutter-11";

    tests = {
      libdirExists = runCommand "mutter-libdir-exists" {} ''
        if [[ ! -d ${finalAttrs.finalPackage.libdir} ]]; then
          echo "passthru.libdir should contain a directory, “${finalAttrs.finalPackage.libdir}” is not one."
          exit 1
        fi
        touch $out
      '';
    };
  };

  meta = with lib; {
    description = "A window manager for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/mutter";
    license = licenses.gpl2Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
  };
})

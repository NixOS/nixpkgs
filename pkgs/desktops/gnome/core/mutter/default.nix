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
, wayland-protocols
}:

let self = stdenv.mkDerivation rec {
  pname = "mutter";
  version = "43.1";

  outputs = [ "out" "dev" "man" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "8vCLJSeDlIpezILwDp6TWmHrv4VkhEvdkniKtEqngmQ=";
  };

  patches = [
    # Fix build with separate sysprof.
    # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2572
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/285a5a4d54ca83b136b787ce5ebf1d774f9499d5.patch";
      sha256 = "/npUE3idMSTVlFptsDpZmGWjZ/d2gqruVlJKq4eF4xU=";
    })

    # Revert clutter optimization causing issues on X11
    # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2667
    # Will be replaced with a proper fix in 43.2
    # https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/6054
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/7e7a639cc5132cf3355e861235f325540fe56548.patch";
      sha256 = "NYoKCRh5o1Q15c11a79Hk5tGKq/jOa+e6GpgBjPEepo=";
      revert = true;
    })

    # Backport edge resistance fix (should be part of 43.2)
    # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2687
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/accf532a29ea9a1d70880dfaa1834050aa3ae7be.patch";
      sha256 = "XAHcPGQFWfZujlqO/cvUryojPCMBBSxeIG06BesDQQw=";
    })
  ];

  mesonFlags = [
    "-Degl_device=true"
    "-Dinstalled_tests=false" # TODO: enable these
    "-Dwayland_eglstream=true"
    "-Dprofiler=true"
    "-Dxwayland_path=${xwayland}/bin/Xwayland"
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
    mesa # needed for gbm
    meson
    ninja
    xvfb-run
    pkg-config
    python3
    wrapGAppsHook
    gi-docgen
    xorgserver # for cvt command
  ];

  buildInputs = [
    cairo
    egl-wayland
    glib
    gnome-desktop
    gnome-settings-daemon
    gobject-introspection
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
    wayland-protocols
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
    moveToOutput "share/mutter-11/doc" "$devdoc"
  '';

  # Install udev files into our own tree.
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  separateDebugInfo = true;

  passthru = {
    libdir = "${self}/lib/mutter-11";

    tests = {
      libdirExists = runCommand "mutter-libdir-exists" {} ''
        if [[ ! -d ${self.libdir} ]]; then
          echo "passthru.libdir should contain a directory, “${self.libdir}” is not one."
          exit 1
        fi
        touch $out
      '';
    };

    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "A window manager for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/mutter";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
};
in self

{ fetchurl, fetchpatch, substituteAll, stdenv, pkgconfig, gnome3, gettext, gobject-introspection, upower, cairo
, pango, cogl, clutter, libstartup_notification, zenity, libcanberra-gtk3
, ninja, xkeyboard_config, libxkbfile, libxkbcommon, libXtst, libinput
, gsettings-desktop-schemas, glib, gtk3, gnome-desktop
, geocode-glib, pipewire, libgudev, libwacom, xwayland, meson
, gnome-settings-daemon
, xorgserver
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "mutter";
  version = "3.32.2";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1h577i2ap7dpfy1jg101jvc6nzccc0csgvd55ahydlr8f94frcva";
  };

  mesonFlags = [
    "-Dxwayland-path=${xwayland}/bin/Xwayland"
    "-Dinstalled_tests=false" # TODO: enable these
  ];

  propagatedBuildInputs = [
    # required for pkgconfig to detect mutter-clutter
    libXtst
  ];

  nativeBuildInputs = [
    meson
    pkgconfig
    gettext
    ninja
    python3
    # for cvt command
    xorgserver
    wrapGAppsHook
  ];

  buildInputs = [
    glib gobject-introspection gtk3 gsettings-desktop-schemas upower
    gnome-desktop cairo pango cogl clutter zenity libstartup_notification
    geocode-glib libinput libgudev libwacom
    libcanberra-gtk3 zenity xkeyboard_config libxkbfile
    libxkbcommon pipewire xwayland
    gnome-settings-daemon
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit zenity;
    })
    # Fix a segmentation fault in dri_flush_front_buffer() upon
    # suspend/resume. This change should be removed when Mutter
    # is updated to 3.34.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/8307c0f7ab60760de53f764e6636893733543be8.diff";
      sha256 = "1hzfva71xdqvvnx5smjsrjlgyrmc7dj94mpylkak0gwda5si0h2n";
    })

    # Fix backported for desktop freezing after ~50 days idle
    # https://mail.gnome.org/archives/distributor-list/2020-April/msg00001.html
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/002299fbef2fd99fb36e5b881ed7b4095ff481f6.patch";
      sha256 = "0x3kk75rqmcsyzhmhxjnh8n8ng4zyrbmh0yzvc79zcphzmdckavb";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/c2e12b3434967e520dcda76bf1d562676e8961ff.patch";
      sha256 = "0l3ckmskxmisbjdhpr30yc2hclyc4l2f0jsgzisnq5aiszy9q0i0";
    })
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "mutter";
      attrPath = "gnome3.mutter";
    };
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
  };
}

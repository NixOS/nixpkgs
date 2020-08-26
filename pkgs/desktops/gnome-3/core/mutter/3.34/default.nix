{ fetchurl
, fetchpatch
, substituteAll
, stdenv
, pkgconfig
, gnome3
, pantheon
, gettext
, gobject-introspection
, upower
, cairo
, pango
, cogl
, json-glib
, libstartup_notification
, zenity
, libcanberra-gtk3
, ninja
, xkeyboard_config
, libxkbfile
, libxkbcommon
, libXtst
, libinput
, gsettings-desktop-schemas
, glib
, gtk3
, gnome-desktop
, geocode-glib
, pipewire_0_2
, libgudev
, libwacom
, xwayland
, meson
, gnome-settings-daemon
, xorgserver
, python3
, wrapGAppsHook
, sysprof
, desktop-file-utils
, libcap_ng
, egl-wayland
}:

stdenv.mkDerivation rec {
  pname = "mutter";
  version = "3.34.5";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1i3r51ghfld1rf1rczzi3jhybz3mhywqcj2jyiqhfcyp1svlklfi";
  };

  mesonFlags = [
    "-Degl_device=true"
    "-Dinstalled_tests=false" # TODO: enable these
    "-Dwayland_eglstream=true"
    "-Dxwayland-path=${xwayland}/bin/Xwayland"
  ];

  propagatedBuildInputs = [
    # required for pkgconfig to detect mutter-clutter
    json-glib
    libXtst
    libcap_ng
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
    xorgserver # for cvt command
  ];

  buildInputs = [
    cairo
    cogl
    egl-wayland
    geocode-glib
    glib
    gnome-desktop
    gnome-settings-daemon
    gobject-introspection
    gsettings-desktop-schemas
    gtk3
    libcanberra-gtk3
    libgudev
    libinput
    libstartup_notification
    libwacom
    libxkbcommon
    libxkbfile
    pango
    pipewire_0_2 # TODO: backport pipewire 0.3 support
    sysprof
    upower
    xkeyboard_config
    xwayland
    zenity
  ];

  patches = [
    # Fix build with libglvnd provided headers
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/a444a4c5f58ea516ad3cd9d6ddc0056c3ca9bc90.patch";
      sha256 = "0imy2j8af9477jliwdq4jc40yw1cifsjjf196gnmwxr9rkj0hbrd";
    })

    # gnome-3-34 2020-04-24
    # also fixes https://mail.gnome.org/archives/distributor-list/2020-April/msg00001.html
    (fetchpatch {
      url = "https://github.com/GNOME/mutter/compare/3.34.5..3bafd234248fdcd84bc62fef5e31c29fbb613909.patch";
      sha256 = "1a7krbdfmvx204p6av44rbp4ckp6ddg1mms8wkixxh2p871zq1pi";
    })

    # Drop inheritable cap_sys_nice, to prevent the ambient set from leaking
    # from mutter/gnome-shell, see https://github.com/NixOS/nixpkgs/issues/71381
    ./drop-inheritable.patch

    # See commit message for details
    ./0001-Fix-glitches-in-gala.patch

    # https://gitlab.gnome.org/GNOME/mutter/merge_requests/1094
    # https://gitlab.gnome.org/GNOME/mutter/merge_requests/957
    ./fix-sysprof.patch

    # profiler: track changes in GLib and Sysprof
    # https://gitlab.gnome.org/GNOME/mutter/merge_requests/908
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/605171291993460f31d470a8143d6438d0c6169c.patch";
      sha256 = "10fxzj0lmic2sp57w26w3r0bv1szngjjs50p3ka22wr9pxqmzl7l";
    })

    # Fixes https://github.com/elementary/wingpanel/issues/305
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/9d390ee49fb1f6300336e82ae94cc8061c6bae12.patch";
      sha256 = "12hmi07rvspwhp8h1y1vmcvmvbh8fihcrb07ja5g0qnh28ip5qfi";
    })

    (substituteAll {
      src = ./fix-paths.patch;
      inherit zenity;
    })
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  meta = with stdenv.lib; {
    description = "A window manager for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/mutter";
    license = licenses.gpl2;
    maintainers = pantheon.maintainers;
    platforms = platforms.linux;
  };
}

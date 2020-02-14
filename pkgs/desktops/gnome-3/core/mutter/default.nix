{ fetchurl
, fetchpatch
, substituteAll
, stdenv
, pkgconfig
, gnome3
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
, pipewire
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
  version = "3.34.3";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "12aaxmclg3aw7qkk3pzpw8f5vrk0cxwprdrjnx9bjpf31gfpvxfd";
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
    pipewire
    sysprof
    upower
    xkeyboard_config
    xwayland
    zenity
    zenity
  ];

  patches = [
    # Fix build with libglvnd provided headers
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/a444a4c5f58ea516ad3cd9d6ddc0056c3ca9bc90.patch";
      sha256 = "0imy2j8af9477jliwdq4jc40yw1cifsjjf196gnmwxr9rkj0hbrd";
    })

    # Drop inheritable cap_sys_nice, to prevent the ambient set from leaking
    # from mutter/gnome-shell, see https://github.com/NixOS/nixpkgs/issues/71381
    ./drop-inheritable.patch

    # TODO: submit upstream
    ./0001-build-use-get_pkgconfig_variable-for-sysprof-dbusdir.patch

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

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "A window manager for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/mutter";
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}

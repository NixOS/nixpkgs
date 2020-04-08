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
, graphene
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "mutter";
  version = "3.36.0";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "18lvj158w6gwc6xpvn699v8ykh1r5szry7sqascl6f1i8g628v2x";
  };

  mesonFlags = [
    "-Degl_device=true"
    "-Dinstalled_tests=false" # TODO: enable these
    "-Dwayland_eglstream=true"
    "-Dprofiler=true"
    "-Dxwayland_path=${xwayland}/bin/Xwayland"
    # This should be auto detected, but it looks like it manages a false
    # positive.
    "-Dxwayland_initfd=disabled"
  ];

  propagatedBuildInputs = [
    # required for pkgconfig to detect mutter-clutter
    json-glib
    libXtst
    libcap_ng
    graphene
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
    wayland-protocols
  ];

  patches = [
    # Drop inheritable cap_sys_nice, to prevent the ambient set from leaking
    # from mutter/gnome-shell, see https://github.com/NixOS/nixpkgs/issues/71381
    ./drop-inheritable.patch

    (substituteAll {
      src = ./fix-paths.patch;
      inherit zenity;
    })

    # Fix crash when opening submenus from «always on visible workspace» windows
    # https://gitlab.gnome.org/GNOME/mutter/issues/1083
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/commit/7e32cc05ce2e5b3931ddcf46ce9ead603a0de39e.patch";
      sha256 = "5ZzOMizucfrSnHNYjHIUObLHCvAIjrE6fY/CxLp4c7k=";
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

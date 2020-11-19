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
  version = "3.34.6";

  outputs = [ "out" "dev" "man" ];

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-I73ofTO4mBNYgxzsiRW7X/Hq+cHedMkM0WYLG5WINSY=";
  };

  mesonFlags = [
    "-Degl_device=true"
    "-Dinstalled_tests=false" # TODO: enable these
    "-Dwayland_eglstream=true"
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
    ./0001-EGL-Include-EGL-eglmesaext.h.patch
    ./0002-drop-inheritable.patch
    ./0003-Fix-glitches-in-gala.patch
    ./0004-profiler-track-changes-in-GLib-and-Sysprof.patch
    ./0005-meta-Add-missing-display.h-to-meta-workspace-manager.h.patch
    ./0006-build-bump-ABI-to-sysprof-capture-4.patch
    (substituteAll {
      src = ./0007-fix-paths.patch;
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

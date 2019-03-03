{ fetchurl, fetchpatch, stdenv, pkgconfig, gnome3, gettext, gobject-introspection, upower, cairo
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
  name = "mutter-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "068zir5c1awmzb31gx94zjykv6c3xb1p5pch7860y3xlihha4s3n";
  };

  mesonFlags = [
    "-Dxwayland-path=${xwayland}/bin/Xwayland"
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

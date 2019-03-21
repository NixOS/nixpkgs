{ fetchurl, stdenv, fetchpatch, pkgconfig, gnome3, intltool, gobject-introspection, upower, cairo
, glib, gtk3, pango, cogl, clutter, libstartup_notification, zenity, libcanberra-gtk3
, gsettings-desktop-schemas, gnome-desktop
, libtool, makeWrapper, xkeyboard_config, libxkbfile, libxkbcommon, libXtst, libinput
, geocode-glib, pipewire, libgudev, libwacom, xwayland, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "mutter-${version}";
  version = "3.28.3";

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/3.28/${name}.tar.xz";
    sha256 = "0vq3rmq20d6b1mi6sf67wkzqys6hw5j7n7fd4hndcp19d5i26149";
  };

  configureFlags = [
    "--with-x"
    "--disable-static"
    "--enable-shape"
    "--enable-sm"
    "--enable-startup-notification"
    "--enable-xsync"
    "--enable-verbose-mode"
    "--with-libcanberra"
    "--with-xwayland-path=${xwayland}/bin/Xwayland"
    "--enable-compile-warnings=maximum"
  ];

  propagatedBuildInputs = [
    # required for pkgconfig to detect mutter-clutter
    libXtst
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig intltool libtool makeWrapper ];

  buildInputs = [
    glib gobject-introspection gtk3 gsettings-desktop-schemas upower
    gnome-desktop cairo pango cogl clutter zenity libstartup_notification
    geocode-glib libinput libgudev libwacom
    libcanberra-gtk3 zenity xkeyboard_config libxkbfile
    libxkbcommon pipewire
  ];

  preFixup = ''
    wrapProgram "$out/bin/mutter" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
  };
}

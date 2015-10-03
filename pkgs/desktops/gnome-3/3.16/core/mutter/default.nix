{ fetchurl, stdenv, pkgconfig, gnome3, intltool, gobjectIntrospection, upower, cairo
, pango, cogl, clutter, libstartup_notification, libcanberra, zenity, libcanberra_gtk3
, libtool, makeWrapper, xkeyboard_config, libxkbfile, libxkbcommon }:


stdenv.mkDerivation rec {
  name = "mutter-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${gnome3.version}/${name}.tar.xz";
    sha256 = "0qq7gpkljn1z45sg2sxvmia52krj4ck2541iar89z99s1cppaasa";
  };

  # fatal error: gio/gunixfdlist.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  configureFlags = "--with-x --disable-static --enable-shape --enable-sm --enable-startup-notification --enable-xsync --enable-verbose-mode --with-libcanberra"; 

  buildInputs = with gnome3;
    [ pkgconfig intltool glib gobjectIntrospection gtk gsettings_desktop_schemas upower
      gnome_desktop cairo pango cogl clutter zenity libstartup_notification libcanberra
      gnome3.geocode_glib
      libcanberra_gtk3 zenity libtool makeWrapper xkeyboard_config libxkbfile libxkbcommon ];

  preFixup = ''
    wrapProgram "$out/bin/mutter" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  patches = [ ./x86.patch ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}

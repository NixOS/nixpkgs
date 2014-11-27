{ fetchurl, stdenv, pkgconfig, gnome3, intltool, gobjectIntrospection, upower, cairo
, pango, cogl, clutter, libstartup_notification, libcanberra, zenity, libcanberra_gtk3
, libtool, makeWrapper, xkeyboard_config, libxkbfile, libxkbcommon }:


stdenv.mkDerivation rec {
  name = "mutter-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${gnome3.version}/${name}.tar.xz";
    sha256 = "aa434c1bfdaf4159ecc2bab2911f7e7b21d64779494ffa5aa4f065b06492373f";
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

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };

}

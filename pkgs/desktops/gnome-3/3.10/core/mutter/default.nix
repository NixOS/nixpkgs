{ fetchurl, stdenv, pkgconfig, gnome3, intltool, gobjectIntrospection, upower, cairo
, pango, cogl, clutter, libstartup_notification, libcanberra, zenity, libcanberra_gtk3
, libtool, makeWrapper }:


stdenv.mkDerivation rec {
  name = "mutter-3.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/3.10/${name}.tar.xz";
    sha256 = "000iclb96mgc4rp2q0cy72nfwyfzl6avijl9nmk87f5sgyy670a3";
  };

  # fatal error: gio/gunixfdlist.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  configureFlags = "--with-x --disable-static --enable-shape --enable-sm --enable-startup-notification --enable-xsync --enable-verbose-mode --with-libcanberra"; 

  buildInputs = with gnome3;
    [ pkgconfig intltool glib gobjectIntrospection gtk gsettings_desktop_schemas upower
      gnome_desktop cairo pango cogl clutter zenity libstartup_notification libcanberra
      libcanberra_gtk3 zenity libtool makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/mutter" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}

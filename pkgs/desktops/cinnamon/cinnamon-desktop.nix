{ stdenv, fetchurl, pkgconfig, autoreconfHook, gobjectIntrospection, intltool, gettext, glib, gnome_common,
libX11, libXrandr, libXext, gtk3, gdk_pixbuf, xkeyboard_config, libxkbfile }:

stdenv.mkDerivation rec {
  name = "cjs";
  version="2.0.4";

  src = fetchurl {
    url = "http://github.com/linuxmint/cinnamon-desktop/archive/${version}.tar.gz";
    sha256 = "1cywin712558pv58c0cr73m25hfcv5x8pv5frvqjr9gwr2gpi6h3";
  };
  
  preConfigure = ''
     gio_include_dir="$(echo "${glib}/include"/gio-*/)"
     export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$gio_include_dir"
    '';

  buildInputs = [
    pkgconfig autoreconfHook
    gobjectIntrospection intltool gettext glib
    gnome_common libX11 libXrandr libXext gtk3
    gdk_pixbuf xkeyboard_config libxkbfile
  ];

  preBuild = "patchShebangs ./scripts";

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "cinnamon-desktop contains the libcinnamon-desktop library, the cinnamon-about
     program as well as some desktop-wide documents." ;

    longDescription = ''
       cinnamon-desktop contains the libcinnamon-desktop library, the cinnamon-about
       program as well as some desktop-wide documents.

       The libcinnamon-desktop library provides API shared by several applications
       on the desktop, but that cannot live in the platform for various
       reasons. There is no API or ABI guarantee, although we are doing our
       best to provide stability. Documentation for the API is available with
       gtk-doc.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.roelof ];
  };
}




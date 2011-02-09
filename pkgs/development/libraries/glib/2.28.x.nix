{ stdenv, fetchurl, pkgconfig, gettext, perl, libiconv, zlib }:

stdenv.mkDerivation rec {
  name = "glib-2.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/2.28/${name}.tar.bz2";
    sha256 = "0605f538e5c022c237c97a34496979ba71d33c7b10b8d8edb84435498a651fb3";
  };

  buildInputs = [ pkgconfig gettext ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv;
  buildNativeInputs = [ perl ];

  propagatedBuildInputs = [ zlib ];

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "GLib, a C library of programming buildings blocks";

    longDescription = ''
      GLib provides the core application building blocks for libraries
      and applications written in C.  It provides the core object
      system used in GNOME, the main loop implementation, and a large
      set of utility functions for strings and common data structures.
    '';

    homepage = http://www.gtk.org/;

    license = "LGPLv2+";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}

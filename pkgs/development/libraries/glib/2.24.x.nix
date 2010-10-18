{ stdenv, fetchurl, pkgconfig, gettext, perl, libiconv, zlib }:

stdenv.mkDerivation rec {
  name = "glib-2.24.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/2.24/${name}.tar.bz2";
    sha256 = "014c3da960bf17117371075c16495f05f36501db990851ceea658f15d2ea6d04";
  };

  buildInputs = [ pkgconfig gettext perl ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv;

  propagatedBuildInputs = [ zlib ];

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

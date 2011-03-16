{ stdenv, fetchurl, pkgconfig, gettext, perl, libiconv, zlib }:

stdenv.mkDerivation rec {
  name = "glib-2.28.3";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/2.28/${name}.tar.bz2";
    sha256 = "7e1ab62d0f0cdc3f0ce8214b77d104b3abbd51185a9f3fc9b6a504cce26f6fab";
  };

  # configure script looks for d-bus but it is only needed for tests
  buildInputs = [ pkgconfig gettext ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv;
  buildNativeInputs = [ perl ];

  propagatedBuildInputs = [ zlib ];

  # glib buildsystem fails to find python, thus hardcodes python2.4 in #!
  postInstall = ''
    rm -rvf $out/share/gtk-doc
    sed -e 's@python2\.4@python@' -i $out/bin/gtester-report'';

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

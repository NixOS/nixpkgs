{ stdenv, fetchurl_gnome, pkgconfig, gettext, perl, libiconv, zlib }:

# TODO:
# * Add gio-module-fam
#     Problem: cyclic dependency on gamin
#     Possible solution: build as a standalone module, set env. vars
stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "glib";
    major = "2"; minor = "28"; patchlevel = "8"; extension = "xz";
    sha256 = "0lw3fjsffpnf0cc4j5lkxgllp95qvfq6bir8nh5gds78pmfsjz2d";
  };

  # configure script looks for d-bus but it is only needed for tests
  buildInputs = stdenv.lib.optional (!stdenv.isLinux) libiconv;
  buildNativeInputs = [ perl pkgconfig gettext ];

  propagatedBuildInputs = [ zlib ]
    ++ stdenv.lib.optional (!stdenv.isLinux) gettext;

  # glib buildsystem fails to find python, thus hardcodes python2.4 in #!
  postInstall = ''
    rm -rvf $out/share/gtk-doc
    sed -e 's@python2\.[0-9]@python@' -i $out/bin/gtester-report'';

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

    maintainers = with stdenv.lib.maintainers; [raskin urkud];
    platforms = stdenv.lib.platforms.linux;
  };
}

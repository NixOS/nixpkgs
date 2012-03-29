{ stdenv, fetchurl, pkgconfig, gettext, perl, libiconv, zlib, libffi
, python, pcre }:

# TODO:
# * Add gio-module-fam
#     Problem: cyclic dependency on gamin
#     Possible solution: build as a standalone module, set env. vars
# * Make it build without python
#     Problem: an example (test?) program needs it.
#     Possible solution: disable compilation of this example somehow
#     Reminder: add 'sed -e 's@python2\.[0-9]@python@' -i
#       $out/bin/gtester-report' to postInstall if this is solved

stdenv.mkDerivation rec {
  name = "glib-2.30.3";

  src = fetchurl {
    url = mirror://gnome/sources/glib/2.30/glib-2.30.3.tar.xz;
    sha256 = "09yxfajynbw78kji48z384lylp67kihfi1g78qrrjif4f5yb5jz6";
  };

  # configure script looks for d-bus but it is only needed for tests
  buildInputs = [ pcre ] ++ stdenv.lib.optional (!stdenv.isLinux) libiconv;
  buildNativeInputs = [ perl pkgconfig gettext python ];

  propagatedBuildInputs = [ zlib libffi ];

  configureFlags = "--with-pcre=system --disable-fam";

  passthru.gioModuleDir = "lib/gio/modules";

  postInstall = ''rm -rvf $out/share/gtk-doc'';

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

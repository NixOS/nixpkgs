{ stdenv, fetchurl_gnome, pkgconfig, gettext, perl, libiconv, zlib, xz, libffi
, python }:

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
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "glib";
    major = "2"; minor = "30"; patchlevel = "0"; extension = "xz";
    sha256 = "1hfdnxf5hsfhkd54390lnc1b14m9n7y031fpma4vpsh96js00k6n";
  };

  # configure script looks for d-bus but it is only needed for tests
  buildInputs = stdenv.lib.optional (!stdenv.isLinux) libiconv;
  buildNativeInputs = [ perl pkgconfig gettext xz python ];

  propagatedBuildInputs = [ zlib libffi ];

  passthru.gioModuleDir = "lib/gio/modules";

  # glib buildsystem fails to find python, thus hardcodes python2.4 in #!
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

{ stdenv, fetchurl, pkgconfig, gettext, perl, libiconv, zlib, libffi, python, pcre }:

stdenv.mkDerivation rec {
  versionMajor = "2.33";
  versionMinor = "3";
  moduleName   = "glib";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1409vc8ac296x341s80q36qvgbzpwpcvxg2xdis5w1vzzxfnkqja";
  };

  # configure script looks for d-bus but it is only needed for tests
  buildInputs = [ pcre ] ++ stdenv.lib.optional (!stdenv.isLinux) libiconv;
  buildNativeInputs = [ perl pkgconfig gettext python ];

  propagatedBuildInputs = [ zlib libffi ];

  configureFlags = "--disable-fam";

  passthru.gioModuleDir = "lib/gio/modules";

  postInstall = "rm -rvf $out/share/gtk-doc";

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

    maintainers = with stdenv.lib.maintainers; [ raskin urkud antono ];
    platforms = stdenv.lib.platforms.linux;
  };
}

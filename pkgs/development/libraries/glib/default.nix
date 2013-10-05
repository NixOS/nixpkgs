{ stdenv, fetchurl, pkgconfig, gettext, perl, python, autoconf, automake, libtool
, libiconvOrEmpty, libintlOrEmpty, zlib, libffi, pcre, libelf, dbus }:

# TODO:
# * Add gio-module-fam
#     Problem: cyclic dependency on gamin
#     Possible solution: build as a standalone module, set env. vars
# * Make it build without python
#     Problem: an example (test?) program needs it.
#     Possible solution: disable compilation of this example somehow
#     Reminder: add 'sed -e 's@python2\.[0-9]@python@' -i
#       $out/bin/gtester-report' to postInstall if this is solved
/*
  * Use --enable-installed-tests for GNOME-related packages,
      and use them as a separately installed tests runned by Hydra
      (they should test an already installed package)
      https://wiki.gnome.org/GnomeGoals/InstalledTests
  * Support org.freedesktop.Application, including D-Bus activation from desktop files
*/

let
  # Some packages don't get "Cflags" from pkgconfig correctly
  # and then fail to build when directly including like <glib/...>.
  # This is intended to be run in postInstall of any package
  # which has $out/include/ containing just some disjunct directories.
  flattenInclude = ''
    for dir in "$out"/include/*; do
      cp -r "$dir"/* "$out/include/"
      rm -r "$dir"
      ln -s . "$dir"
    done
    ln -sr -t "$out/include/" "$out"/lib/*/include/* 2>/dev/null || true
  '';

  ver_maj = "2.38";
  ver_min = "0";
in
with { inherit (stdenv.lib) optionalString; };

stdenv.mkDerivation rec {
  name = "glib-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/${ver_maj}/${name}.tar.xz";
    sha256 = "0cpzqadqk6z6bmb79p04pykxc8x57rvshh33414cnk41bvgaf4vm";
  };

  # configure script looks for d-bus but it is (probably) only needed for tests
  buildInputs = [ libelf ];

  # I don't know why the autotools are needed now, even without modifying configure scripts
  nativeBuildInputs = [ pkgconfig gettext perl python ] ++ [ autoconf automake libtool ];

  propagatedBuildInputs = [ pcre zlib libffi ] ++ libiconvOrEmpty ++ libintlOrEmpty;

  preConfigure = "autoreconf -fi";
  configureFlags = "--with-pcre=system --disable-fam";

  NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin "-lintl";

  enableParallelBuilding = true;

  doCheck = false; # ToDo: fix the remaining problems, so we have checked glib by default
  LD_LIBRARY_PATH = optionalString doCheck "${stdenv.gcc.gcc}/lib";

  postInstall = ''rm -rvf $out/share/gtk-doc'';

  passthru = {
     gioModuleDir = "lib/gio/modules";
     inherit flattenInclude;
  };

  meta = with stdenv.lib; {
    description = "GLib, a C library of programming buildings blocks";
    homepage    = http://www.gtk.org/;
    license     = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 raskin urkud ];
    platforms   = platforms.unix;

    longDescription = ''
      GLib provides the core application building blocks for libraries
      and applications written in C.  It provides the core object
      system used in GNOME, the main loop implementation, and a large
      set of utility functions for strings and common data structures.
    '';
  };
}

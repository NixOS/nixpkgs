{ stdenv, fetchurl, pkgconfig, gettext, perl, python
, libiconvOrEmpty, libintlOrEmpty, zlib, libffi, pcre, libelf

# this is just for tests (not in closure of any regular package)
, libxml2, tzdata, desktop_file_utils, shared_mime_info, doCheck ? false
}:

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
  ver_min = "2";
in
with { inherit (stdenv.lib) optional optionals optionalString; };

stdenv.mkDerivation rec {
  name = "glib-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/${ver_maj}/${name}.tar.xz";
    sha256 = "0d2px8m77603s5pm3md4bcm5d0ksbcsb6ik1w52hjslnq1a9hsh5";
  };

  buildInputs = [ libelf ]
    ++ optionals doCheck [ tzdata libxml2 desktop_file_utils shared_mime_info ];

  nativeBuildInputs = [ pkgconfig gettext perl python ];

  propagatedBuildInputs = [ pcre zlib libffi ] ++ libiconvOrEmpty ++ libintlOrEmpty;

  configureFlags =
    optional stdenv.isDarwin "--disable-compile-warnings"
    ++ optional stdenv.isSunOS "--disable-modular-tests";

  NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin " -lintl"
    + optionalString stdenv.isSunOS " -DBSD_COMP";

  enableParallelBuilding = true;

  inherit doCheck;
  preCheck = optionalString doCheck
    # libgcc_s.so.1 must be installed for pthread_cancel to work
    # also point to the glib/.libs path
    '' export LD_LIBRARY_PATH="$(dirname $(echo ${stdenv.gcc.gcc}/lib*/libgcc_s.so)):$NIX_BUILD_TOP/${name}/glib/.libs:$LD_LIBRARY_PATH"
       export TZDIR="${tzdata}/share/zoneinfo"
       export XDG_CACHE_HOME="$TMP"
       export XDG_RUNTIME_HOME="$TMP"
       export HOME="$TMP"
       export XDG_DATA_DIRS="${desktop_file_utils}/share:${shared_mime_info}/share"
    '';

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

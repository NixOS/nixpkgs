{ stdenv, fetchurl, pkgconfig, gettext, perl, libiconvOrEmpty, zlib, libffi
, python, pcre, libelf, libintlOrEmpty }:

# TODO:
# * Add gio-module-fam
#     Problem: cyclic dependency on gamin
#     Possible solution: build as a standalone module, set env. vars
# * Make it build without python
#     Problem: an example (test?) program needs it.
#     Possible solution: disable compilation of this example somehow
#     Reminder: add 'sed -e 's@python2\.[0-9]@python@' -i
#       $out/bin/gtester-report' to postInstall if this is solved

let
  # some packages don't get "Cflags" from pkgconfig correctly
  # and then fail to build when directly including like <glib/...>
  flattenInclude = ''
    for dir in $out/include/*; do
      cp -r $dir/* "$out/include/"
      rm -r "$dir"
      ln -s . "$dir"
    done
    ln -sr -t "$out/include/" $out/lib/*/include/* 2>/dev/null || true
  '';
in

stdenv.mkDerivation rec {
  name = "glib-2.36.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/2.36/${name}.tar.xz";
    sha256 = "090bw5par3dfy5m6dhq393pmy92zpw3d7rgbzqjc14jfg637bqvx";
  };

  outputs = [ "dev" "out" "bin" ];

  # configure script looks for d-bus but it is only needed for tests
  buildInputs = [ libelf ] ++ libintlOrEmpty;

  nativeBuildInputs = [ perl pkgconfig gettext python ];

  propagatedBuildInputs = [ pcre zlib libffi ] ++ libiconvOrEmpty;

  configureFlags = "--with-pcre=system --disable-fam";

  postConfigure = "sed '/SANE_MALLOC_PROTOS/s,^,//,' -i config.h";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  enableParallelBuilding = true;

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


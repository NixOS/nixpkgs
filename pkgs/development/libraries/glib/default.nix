{ stdenv, fetchurl, pkgconfig, gettext, perl, libiconvOrEmpty, zlib, libffi
, python, pcre, libelf }:

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

stdenv.mkDerivation (rec {
  name = "glib-2.36.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/2.36/${name}.tar.xz";
    sha256 = "090bw5par3dfy5m6dhq393pmy92zpw3d7rgbzqjc14jfg637bqvx";
  };

  # configure script looks for d-bus but it is only needed for tests
  buildInputs = [ libelf ] ++ libiconvOrEmpty;

  nativeBuildInputs = [ perl pkgconfig gettext python ];

  propagatedBuildInputs = [ pcre zlib libffi ];

  configureFlags = "--with-pcre=system --disable-fam";

  postConfigure = "sed '/SANE_MALLOC_PROTOS/s,^,//,' -i config.h"; # https://bugzilla.gnome.org/show_bug.cgi?id=698716 :-)

  enableParallelBuilding = true;

  postInstall = ''rm -rvf $out/share/gtk-doc'';

  passthru = {
     gioModuleDir = "lib/gio/modules";
     inherit flattenInclude;
  };

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

//

(stdenv.lib.optionalAttrs stdenv.isDarwin {
  # XXX: Disable the NeXTstep back-end because stdenv.gcc doesn't support
  # Objective-C.
  postConfigure =
    '' sed -i configure -e's/glib_have_cocoa=yes/glib_have_cocoa=no/g'
    '';
}))

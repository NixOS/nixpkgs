{ stdenv, fetchurl, pkgconfig, gettext, perl, libiconvOrNull, zlib, libffi
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

stdenv.mkDerivation (rec {
  name = "glib-2.34.3";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/2.34/${name}.tar.xz";
    sha256 = "19sq4rhl2vr8ikjvl8qh51vr38yqfhbkb3imi2s6ac5rgkwcnpw5";
  };

  # configure script looks for d-bus but it is only needed for tests
  buildInputs = [ libiconvOrNull ];

  buildNativeInputs = [ perl pkgconfig gettext python ];

  propagatedBuildInputs = [ pcre zlib libffi ];

  configureFlags = "--with-pcre=system --disable-fam";

  enableParallelBuilding = true;

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

//

(stdenv.lib.optionalAttrs stdenv.isDarwin {
  # XXX: Disable the NeXTstep back-end because stdenv.gcc doesn't support
  # Objective-C.
  postConfigure =
    '' sed -i configure -e's/glib_have_cocoa=yes/glib_have_cocoa=no/g'
    '';
}))

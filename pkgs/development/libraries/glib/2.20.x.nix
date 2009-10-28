{ stdenv, fetchurl, pkgconfig, gettext, perl }:

stdenv.mkDerivation rec {
  name = "glib-2.20.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glib/2.20/${name}.tar.bz2";
    sha256 = "0ndgshcqzpj3piwmag3vrsv3rg4pnr12y70knl7z0k2i03cy5bav";
  };

  buildInputs = [pkgconfig gettext perl];

  # The nbd package depends on a static version of this library; hence
  # the default configure flag --disable-static is switched off.
  dontDisableStatic = true;
  configureFlags = "--enable-static --enable-shared";

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
  };
}

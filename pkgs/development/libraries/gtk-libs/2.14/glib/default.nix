args: with args;

stdenv.mkDerivation rec {
  name = "glib-2.18.4";
  
  src = fetchurl {
    url = "mirror://gnome/sources/glib/2.18/${name}.tar.bz2";
    sha256 = "00711nscyya6j1kdda7sbxy01qspccpvmnmc8f4kip4zbs22rsva";
  };
  
  buildInputs = [pkgconfig gettext perl];

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

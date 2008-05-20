args: with args;

stdenv.mkDerivation {
  name = "glib-2.16.3";
  
  src = fetchurl {
    url = mirror://gnome/sources/glib/2.16/glib-2.16.3.tar.bz2;
    md5 = "195f9a803cc5279dbb39afdf985f44cb";
  };
  
  buildInputs = [pkgconfig gettext perl];

  meta = {
    description = "A C library providing non-GUI functionality";
    homepage = http://www.gtk.org/;
  };
}

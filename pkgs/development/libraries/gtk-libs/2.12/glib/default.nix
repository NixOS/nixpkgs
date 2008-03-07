args: with args;

stdenv.mkDerivation {
  name = "glib-2.14.6";
  
  src = fetchurl {
    url = mirror://gnome/sources/glib/2.14/glib-2.14.6.tar.bz2;
    sha256 = "1fi4xb07d7bfnfi65snvbi6i5kzhr3kad8knbwklj47z779vppvq";
  };
  
  buildInputs = [pkgconfig gettext perl];

  meta = {
    description = "A C library providing non-GUI functionality";
    homepage = http://www.gtk.org/;
  };
}

args: with args;

stdenv.mkDerivation {
  name = "glib-2.16.3";
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/GNOME/sources/glib/2.16/glib-2.16.3.tar.bz2;
    sha256 = "0zc8irn9zx8j37ih3jiwhqrkq2ddpv4x93pcj7c45f676ji449sn";
  };
  buildInputs = [pkgconfig gettext perl];
}

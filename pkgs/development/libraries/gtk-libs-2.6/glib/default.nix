{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.6.2";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/glib-2.6.2.tar.bz2;
    md5 = "31fafaf9b1a96ab804c078fb965eb529";
  };
  buildInputs = [pkgconfig gettext perl];
}

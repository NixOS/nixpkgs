{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.6.3";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/glib-2.6.3.tar.bz2;
    md5 = "8f69ad5387197114b356efc64ce88d77";
  };
  buildInputs = [pkgconfig gettext perl];
}

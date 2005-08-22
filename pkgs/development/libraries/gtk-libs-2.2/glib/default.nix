{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.2.3";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/glib-2.2.3.tar.bz2;
    md5 = "aa214a10d873b68ddd67cd9de2ccae55";
  };
  buildInputs = [pkgconfig gettext perl];
}

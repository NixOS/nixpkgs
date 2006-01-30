{stdenv, fetchurl, perl, perlXMLParser, pkgconfig, libxml2, glib}:

stdenv.mkDerivation {
  name = "libgsf-1.13.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libgsf-1.13.2.tar.bz2;
    md5 = "0894afd88f9e43eada27e52cb22cd0f1";
  };
  buildInputs = [perl perlXMLParser pkgconfig libxml2 glib];
}

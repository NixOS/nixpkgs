{stdenv, fetchurl, pkgconfig, perl, glib, gtk, libxml2, ORBit2, popt}:

assert pkgconfig != null && perl != null
  && glib != null && gtk != null
  && libxml2 != null && ORBit2 != null && popt != null;

stdenv.mkDerivation {
  name = "GConf-2.4.0.1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/GConf-2.4.0.1.tar.bz2;
    md5 = "2f7548d0bad24d7c4beba54d0ec98a20";
  };
  # Perl is not `supposed' to be required, but it is.
  buildInputs = [pkgconfig perl glib gtk libxml2 popt];
  propagatedBuildInputs = [ORBit2];
}

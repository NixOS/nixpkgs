{stdenv, fetchurl, pkgconfig, glib, perl}:

assert pkgconfig != null && glib != null && perl != null;

stdenv.mkDerivation {
  name = "atk-1.9.0";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/atk-1.9.0.tar.bz2;
    md5 = "7f41bd9c6dcd83c8df391dc1805be653";
  };
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [glib];
}

{stdenv, fetchurl, pkgconfig, gtk, libart, libglade}:

assert pkgconfig != null && gtk != null && libart != null
  && libglade != null;

stdenv.mkDerivation {
  name = "libgnomecanvas-2.4.0";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/desktop/2.4/2.4.1/sources/libgnomecanvas-2.4.0.tar.bz2;
    md5 = "c212a7cac06b7f9e68ed2de38df6e54d";
  };
  buildInputs = [pkgconfig libglade];
  propagatedBuildInputs = [gtk libart];
}

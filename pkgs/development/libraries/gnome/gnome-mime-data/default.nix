{stdenv, fetchurl, pkgconfig, perl}:

assert pkgconfig != null && perl != null;

stdenv.mkDerivation {
  name = "gnome-mime-data-2.4.0";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/desktop/2.4/2.4.1/sources/gnome-mime-data-2.4.0.tar.bz2;
    md5 = "b8f1b383a23d734bec8bc33a03cb3690";
  };
  buildInputs = [pkgconfig perl];
}

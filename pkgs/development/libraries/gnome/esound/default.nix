{stdenv, fetchurl, audiofile}:

assert audiofile != null;

stdenv.mkDerivation {
  name = "esound-0.2.32";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/desktop/2.4/2.4.1/sources/esound-0.2.32.tar.bz2;
    md5 = "b2a5e71ec8220fea1c22cc042f5f6e63";
  };
  propagatedBuildInputs = [audiofile];
}

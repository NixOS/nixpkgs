args: with args;

stdenv.mkDerivation {
  name = "atk-1.12.4";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/gnome/sources/atk/1.22/atk-1.22.0.tar.bz2;
    sha256 = "1sax4a63v7vy2f23lqgy33956nglas9vyh4dq91914gwl3lnczb7";
  };
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [glib];
}

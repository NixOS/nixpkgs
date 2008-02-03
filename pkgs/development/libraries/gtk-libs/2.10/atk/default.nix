args: with args;

stdenv.mkDerivation {
  name = "atk-1.12.4";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/gnome/sources/atk/1.12/atk-1.12.4.tar.bz2;
    md5 = "0a2c6a7bbc380e3a3d94e9061f76a849";
  };
  buildInputs = [pkgconfig perl];
  propagatedBuildInputs = [glib];
}

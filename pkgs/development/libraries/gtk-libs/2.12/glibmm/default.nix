args: with args;

stdenv.mkDerivation {
  name = "glibmm-2.16.1";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.16/glibmm-2.16.1.tar.bz2;
    sha256 = "0x710y9pkn4nfhl95dqfk90bk29qr5alzqxdl3l1n6af5yl2yn3i";
  };

  buildInputs = [pkgconfig];
  propagatedBuildInputs = [glib libsigcxx];
}


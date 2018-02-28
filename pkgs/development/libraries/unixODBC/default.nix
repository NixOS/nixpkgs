{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "unixODBC-${version}";
  version = "2.3.5";

  src = fetchurl {
    url = "ftp://ftp.unixodbc.org/pub/unixODBC/${name}.tar.gz";
    sha256 = "0ns93daph4wmk92d7m2w48x0yki4m1yznxnn97p1ldn6bkh742bn";
  };

  configureFlags = [ "--disable-gui" "--sysconfdir=/etc" ];

  meta = with stdenv.lib; {
    description = "ODBC driver manager for Unix";
    homepage = http://www.unixodbc.org/;
    license = licenses.lgpl2;
    platforms = platforms.unix;
  };
}

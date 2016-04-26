{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "unixODBC-${version}";
  version = "2.3.4";

  src = fetchurl {
    url = "ftp://ftp.unixodbc.org/pub/unixODBC/${name}.tar.gz";
    sha256 = "0f8y88rcc2akjvjv5y66yx7k0ms9h1s0vbcfy25j93didflhj59f";
  };

  configureFlags = [ "--disable-gui" "--sysconfdir=/etc" ];

  meta = with stdenv.lib; {
    description = "ODBC driver manager for Unix";
    homepage = http://www.unixodbc.org/;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}

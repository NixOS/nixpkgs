{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "unixODBC";
  version = "2.3.7";

  src = fetchurl {
    url = "ftp://ftp.unixodbc.org/pub/unixODBC/${pname}-${version}.tar.gz";
    sha256 = "0xry3sg497wly8f7715a7gwkn2k36bcap0mvzjw74jj53yx6kwa5";
  };

  configureFlags = [ "--disable-gui" "--sysconfdir=/etc" ];

  meta = with stdenv.lib; {
    description = "ODBC driver manager for Unix";
    homepage = "http://www.unixodbc.org/";
    license = licenses.lgpl2;
    platforms = platforms.unix;
  };
}

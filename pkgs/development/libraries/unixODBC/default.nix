{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "unixODBC-${version}";
  version = "2.3.6";

  src = fetchurl {
    url = "ftp://ftp.unixodbc.org/pub/unixODBC/${name}.tar.gz";
    sha256 = "0sads5b8cmmj526gyjba7ccknl1vbhkslfqshv1yqln08zv3gdl8";
  };

  configureFlags = [ "--disable-gui" "--sysconfdir=/etc" ];

  meta = with stdenv.lib; {
    description = "ODBC driver manager for Unix";
    homepage = http://www.unixodbc.org/;
    license = licenses.lgpl2;
    platforms = platforms.unix;
  };
}

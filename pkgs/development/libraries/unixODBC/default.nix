{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "unixODBC-2.2.11";
  src = fetchurl {
    url = mirror://sourceforge/unixodbc/unixODBC-2.2.11.tar.gz;
    md5 = "9ae806396844e38244cf65ad26ba0f23";
  };
  configureFlags = "--disable-gui --sysconfdir=/etc";
}

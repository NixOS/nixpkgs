{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "unixODBC-2.3.1";
  src = fetchurl {
    url = "ftp://ftp.unixodbc.org/pub/unixODBC/${name}.tar.gz";
    md5 = "86788d4006620fa1f171c13d07fdcaab";
  };
  configureFlags = "--disable-gui --sysconfdir=/etc";
}

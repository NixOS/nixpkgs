{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "freetds-0.91";

  src = fetchurl {
    url = ftp://ftp.astron.com/pub/freetds/stable/freetds-stable.tgz;
    sha256 = "0r946axzxs0czsmr7283w7vmk5jx3jnxxc32d2ncxsrsh2yli0ba";
  };

  meta = {
    description =
      "Libraries to natively talk to Microsoft SQL Server and Sybase databases";
    homepage = "http://www.freetds.org";
    license = "lgpl";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.all;
  };
}


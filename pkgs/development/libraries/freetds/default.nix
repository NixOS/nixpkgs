{ stdenv, fetchurl
, odbcSupport ? false, unixODBC ? null }:

assert odbcSupport -> unixODBC != null;

stdenv.mkDerivation rec {
  name = "freetds-0.91";

  src = fetchurl {
    url = "http://mirrors.ibiblio.org/freetds/stable/${name}.tar.gz";
    sha256 = "0r946axzxs0czsmr7283w7vmk5jx3jnxxc32d2ncxsrsh2yli0ba";
  };

  hardeningDisable = [ "format" ];

  buildInputs = stdenv.lib.optional odbcSupport [ unixODBC ];

  configureFlags = stdenv.lib.optionalString odbcSupport "--with-odbc=${unixODBC}";

  doDist = true;

  distPhase = ''
    touch $out/include/tds.h
    touch $out/lib/libtds.a
  '';

  meta = {
    description =
      "Libraries to natively talk to Microsoft SQL Server and Sybase databases";
    homepage = "http://www.freetds.org";
    license = "lgpl";
    platforms = stdenv.lib.platforms.all;
  };
}

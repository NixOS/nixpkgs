{ stdenv, fetchurl
, odbcSupport ? false, unixODBC ? null }:

assert odbcSupport -> unixODBC != null;

stdenv.mkDerivation rec {
  name = "freetds-0.91.112";

  src = fetchurl {
    url = "ftp://ftp.astron.com/pub/freetds/stable/${name}.tar.gz";
    sha256 = "be4f04ee57328c32e7e7cd7e2e1483e535071cec6101e46b9dd15b857c5078ed";
  };

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


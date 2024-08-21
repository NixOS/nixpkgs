{ lib, stdenv, fetchurl, postgresql, openssl
, withLibiodbc ? false, libiodbc
, withUnixODBC ? true, unixODBC
}:

assert lib.xor withLibiodbc withUnixODBC;

stdenv.mkDerivation rec {
  pname = "psqlodbc";
  version = "16.00.0000";

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-${version}.tar.gz";
    hash = "sha256-r9iS+J0uzujT87IxTxvVvy0CIBhyxuNDHlwxCW7KTIs=";
  };

  buildInputs = [
    postgresql
    openssl
  ]
  ++ lib.optional withLibiodbc libiodbc
  ++ lib.optional withUnixODBC unixODBC;

  passthru = lib.optionalAttrs withUnixODBC {
    fancyName = "PostgreSQL";
    driver = "lib/psqlodbcw.so";
  };

  configureFlags = [
    "--with-libpq=${lib.getDev postgresql}/bin/pg_config"
  ]
  ++ lib.optional withLibiodbc "--with-iodbc=${libiodbc}";

  meta = with lib; {
    homepage = "https://odbc.postgresql.org/";
    description = "ODBC driver for PostgreSQL";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}

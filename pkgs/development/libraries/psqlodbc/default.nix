{ lib, stdenv, fetchurl, libiodbc, postgresql, openssl }:

stdenv.mkDerivation rec {
  pname = "psqlodbc";
  version = "13.02.0000";

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-${version}.tar.gz";
    hash = "sha256-s5t+XEH9ZHXFUREvpyS/V8SkRhdexBiKkOKETMFhJYU=";
  };

  buildInputs = [ libiodbc postgresql openssl ];

  configureFlags = [
    "--with-iodbc=${libiodbc}"
    "--with-libpq=${lib.getDev postgresql}/bin/pg_config"
  ];

  meta = with lib; {
    homepage = "https://odbc.postgresql.org/";
    description = "ODBC driver for PostgreSQL";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}

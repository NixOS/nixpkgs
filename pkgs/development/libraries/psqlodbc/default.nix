{ lib, stdenv, fetchurl, libiodbc, postgresql, openssl }:

stdenv.mkDerivation rec {
  pname = "psqlodbc";
  version = "09.01.0200";

  src = fetchurl {
    url = "https://ftp.postgresql.org/pub/odbc/versions/src/${pname}-${version}.tar.gz";
    sha256 = "0b4w1ahfpp34jpscfk2kv9050lh3xl9pvcysqvaigkcd0vsk1hl9";
  };

  buildInputs = [ libiodbc postgresql openssl ];

  configureFlags = [ "--with-iodbc=${libiodbc}" ];

  meta = with lib; {
    homepage = "https://odbc.postgresql.org/";
    description = "ODBC driver for PostgreSQL";
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}

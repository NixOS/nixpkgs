{ lib, stdenv, fetchurl, postgresql, python2, gnused }:

stdenv.mkDerivation rec {
  name = "libpqxx-4.0.1";

  src = fetchurl {
    url = "http://pqxx.org/download/software/libpqxx/${name}.tar.gz";
    sha256 = "0f6wxspp6rx12fkasanb0z2g2gc8dhcfwnxagx8wwqbpg6ifsz09";
  };

  buildInputs = [ postgresql python2 gnused ];

  preConfigure = ''
    patchShebangs .
  '';

  configureFlags = "--enable-shared";

  meta = {
    description = "A C++ library to access PostgreSQL databases";
    homepage = http://pqxx.org/development/libpqxx/;
    license = lib.licenses.postgresql;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco ];
  };
}

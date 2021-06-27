{ lib, stdenv, fetchFromGitHub, postgresql, python3, gnused }:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "7.5.2";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = pname;
    rev = version;
    sha256 = "15ifd28v6xbbx931icydy8xmkd8030b20xzqjja6vwwvzss2w9fa";
  };

  nativeBuildInputs = [ gnused python3 ];
  buildInputs = [ postgresql ];

  preConfigure = ''
    patchShebangs ./tools/splitconfig
  '';

  configureFlags = [ "--enable-shared --disable-documentation" ];

  meta = {
    description = "A C++ library to access PostgreSQL databases";
    homepage = "http://pqxx.org/development/libpqxx/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.eelco ];
  };
}

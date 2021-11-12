{ lib, stdenv, fetchFromGitHub, postgresql, python3, gnused }:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "7.6.0";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = pname;
    rev = version;
    sha256 = "sha256-shcGJebjXJ3ORvcdINJFLiuW7ySqe6HyPUQioeUG/wM=";
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

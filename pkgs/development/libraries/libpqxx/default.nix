{ lib, stdenv, fetchFromGitHub, postgresql, python2, gnused }:

stdenv.mkDerivation rec {
  name = "libpqxx-${version}";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = "libpqxx";
    rev = version;
    sha256 = "1dv96h10njg115216n2zm6fsvi4kb502hmhhn8cjhlfbxr9vc84q";
  };

  nativeBuildInputs = [ gnused python2 ];
  buildInputs = [ postgresql ];

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

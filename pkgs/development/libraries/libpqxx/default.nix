{ lib, stdenv, fetchFromGitHub, postgresql, doxygen, xmlto, python2, gnused }:

stdenv.mkDerivation rec {
  name = "libpqxx-${version}";
  version = "6.2.2";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = "libpqxx";
    rev = version;
    sha256 = "0f7mkl29v6d47kkdpl2gkb9xc5lnih2pq9pk3cq6nc2j6w758yp5";
  };

  nativeBuildInputs = [ gnused python2 ];
  buildInputs = [ postgresql doxygen xmlto ];

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

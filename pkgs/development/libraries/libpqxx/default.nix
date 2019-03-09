{ lib, stdenv, fetchFromGitHub, postgresql, doxygen, xmlto, python2, gnused }:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = pname;
    rev = version;
    sha256 = "1gfi4ghnhzlkdza2ifvg6b2rk5qn0swq7ykphwmwalb166vj2wlx";
  };

  nativeBuildInputs = [ gnused python2 ];
  buildInputs = [ postgresql doxygen xmlto ];

  preConfigure = ''
    patchShebangs .
  '';

  configureFlags = [ "--enable-shared" ];

  meta = {
    description = "A C++ library to access PostgreSQL databases";
    homepage = http://pqxx.org/development/libpqxx/;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco ];
  };
}

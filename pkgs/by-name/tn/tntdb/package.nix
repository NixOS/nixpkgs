{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, cxxtools
, postgresql
, libmysqlclient
, sqlite
, zlib
, openssl
}:

stdenv.mkDerivation rec {
  pname = "tntdb";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "maekitalo";
    repo = "tntdb";
    rev = "V${version}";
    hash = "sha256-ciqHv077sXnvCx+TJjdY1uPrlCP7/s972koXjGLgWhU=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    cxxtools
    postgresql
    libmysqlclient
    sqlite
    zlib
    openssl
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.tntnet.org/tntdb.html";
    description = "C++ library which makes accessing SQL databases easy and robust";
    platforms = platforms.linux;
    license = licenses.lgpl21;
    maintainers = [ maintainers.juliendehos ];
  };
}

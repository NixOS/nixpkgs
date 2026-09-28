{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cxxtools,
  libpq,
  libmysqlclient,
  sqlite,
  zlib,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tntdb";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "maekitalo";
    repo = "tntdb";
    rev = "V${finalAttrs.version}";
    hash = "sha256-ciqHv077sXnvCx+TJjdY1uPrlCP7/s972koXjGLgWhU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libpq.pg_config
  ];

  buildInputs = [
    cxxtools
    libpq
    libmysqlclient
    sqlite
    zlib
    openssl
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.tntnet.org/tntdb.html";
    description = "C++ library which makes accessing SQL databases easy and robust";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.juliendehos ];
  };
})

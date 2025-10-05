{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  openssl,
  c-ares,
  readline,
  icu,
  git,
  gbenchmark,
  nghttp2,
}:

stdenv.mkDerivation rec {
  pname = "tarantool";
  version = "2.10.4";

  src = fetchFromGitHub {
    owner = "tarantool";
    repo = "tarantool";
    tag = version;
    hash = "sha256-yCRU5IxC6gNS+O2KYtKWjFk35EHkBnnzWy5UnyuB9f4=";
    fetchSubmodules = true;
  };

  buildInputs = [
    nghttp2
    git
    readline
    icu
    zlib
    openssl
    c-ares
  ];

  nativeCheckInputs = [ gbenchmark ];

  nativeBuildInputs = [ cmake ];

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [
    "-DENABLE_DIST=ON"
    "-DTARANTOOL_VERSION=${version}.builtByNix" # expects the commit hash as well
  ];

  meta = with lib; {
    description = "In-memory computing platform consisting of a database and an application server";
    homepage = "https://www.tarantool.io/";
    license = licenses.bsd2;
    mainProgram = "tarantool";
    maintainers = with maintainers; [ dit7ya ];
  };
}

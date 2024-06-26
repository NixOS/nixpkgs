{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
  zeromq,
  czmq,
  libsodium,
}:

stdenv.mkDerivation rec {
  pname = "prime-server";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "kevinkreiser";
    repo = "prime_server";
    rev = version;
    sha256 = "0izmmvi3pvidhlrgfpg4ccblrw6fil3ddxg5cfxsz4qbh399x83w";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    curl
    zeromq
    czmq
    libsodium
  ];

  # https://github.com/kevinkreiser/prime_server/issues/95
  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=unused-variable" ];

  meta = with lib; {
    description = "Non-blocking (web)server API for distributed computing and SOA based on zeromq";
    homepage = "https://github.com/kevinkreiser/prime_server";
    license = licenses.bsd2;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}

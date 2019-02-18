{ fetchFromGitHub, stdenv, cmake, openssl, zlib, libuv }:

stdenv.mkDerivation rec {
  name = "libwebsockets-${version}";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "warmcat";
    repo = "libwebsockets";
    rev = "v${version}";
    sha256 = "1w1wz6snf3cmcpa3f4dci2nz9za2f5rrylxl109id7bcb36xhbdl";
  };

  buildInputs = [ cmake openssl zlib libuv ];
  cmakeFlags = [ "-DLWS_WITH_PLUGINS=ON" ];

  meta = {
    description = "Light, portable C library for websockets";
    longDescription = ''
      Libwebsockets is a lightweight pure C library built to
      use minimal CPU and memory resources, and provide fast
      throughput in both directions.
    '';
    homepage = https://libwebsockets.org;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.all;
  };
}

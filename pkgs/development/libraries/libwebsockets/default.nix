{ fetchFromGitHub, stdenv, cmake, openssl, zlib, libuv }:

stdenv.mkDerivation rec {
  pname = "libwebsockets";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "warmcat";
    repo = "libwebsockets";
    rev = "v${version}";
    sha256 = "0ac5755h3w1pl6cznqbvg63dwkqy544fqlhvqyp7s11hgs7jx6l8";
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
    homepage = https://github.com/warmcat/libwebsockets;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.all;
  };
}

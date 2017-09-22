{ fetchFromGitHub, stdenv, cmake, openssl, zlib, libuv }:

stdenv.mkDerivation rec {
  name = "libwebsockets-${version}";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "warmcat";
    repo = "libwebsockets";
    rev = "v${version}";
    sha256 = "1hv2b5r6sg42xnqhm4ysjvyiz3cqpfmwaqm33vpbx0k7arj4ixvy";
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
    homepage = https://libwebsockets.org/trac/libwebsockets;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}

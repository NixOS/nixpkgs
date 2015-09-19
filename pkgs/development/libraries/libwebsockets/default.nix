{ fetchgit, stdenv, cmake, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "libwebsockets-1.4";

  src = fetchgit {
    url = "git://git.libwebsockets.org/libwebsockets";
    rev = "16fb0132cec0fcced29bce6d86eaf94a9beb9785";
    sha256 = "fa4c81f86dfc39211b78c53c804efc19e15b81ccb05e72699220bbed27204c7d";
  };

  buildInputs = [ cmake openssl zlib ];

  meta = {
    description = "Light, portable C library for websockets";
    longDescription = ''
      Libwebsockets is a lightweight pure C library built to
      use minimal CPU and memory resources, and provide fast
      throughput in both directions.
    '';
    homepage = https://libwebsockets.org/trac/libwebsockets;
    # See http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/tree/LICENSE
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}

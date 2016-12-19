{ fetchgit, stdenv, cmake, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "libwebsockets-1.4";

  src = fetchgit {
    url = "git://git.libwebsockets.org/libwebsockets";
    rev = "16fb0132cec0fcced29bce6d86eaf94a9beb9785";
    sha256 = "0gk4dgx125nz7wl59bx0kgxxg261r9kyxvdff5ld98slr9f08d0l";
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

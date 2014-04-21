{ stdenv, zlib, autoconf, automake, libtool }:

stdenv.mkDerivation {
  name = "minizip-${zlib.version}";
  inherit (zlib) src;

  nativeBuildInputs = [ autoconf automake libtool ];
  buildInputs = [ zlib ];

  preConfigure = ''
    cd contrib/minizip
    autoreconf -vfi
  '';
}

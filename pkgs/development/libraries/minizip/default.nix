{ stdenv, zlib, autoreconfHook }:

stdenv.mkDerivation {
  name = "minizip-${zlib.version}";
  inherit (zlib) src;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  sourceRoot = "zlib-${zlib.version}/contrib/minizip";

  meta = {
    description = "Compression library implementing the deflate compression method found in gzip and PKZIP";
    inherit (zlib.meta) license homepage;
    platforms = stdenv.lib.platforms.unix;
  };
}

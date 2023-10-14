{ lib, stdenv, zlib, autoreconfHook }:

stdenv.mkDerivation {
  pname = "minizip";
  inherit (zlib) src version;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  sourceRoot = "zlib-${zlib.version}/contrib/minizip";

  meta = {
    description = "Compression library implementing the deflate compression method found in gzip and PKZIP";
    inherit (zlib.meta) license homepage;
    platforms = lib.platforms.unix;
  };
}

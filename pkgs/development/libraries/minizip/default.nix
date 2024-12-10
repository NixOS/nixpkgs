{
  lib,
  stdenv,
  zlib,
  autoreconfHook,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "minizip";
  inherit (zlib) src version;

  patchFlags = [ "-p3" ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  sourceRoot = "zlib-${zlib.version}/contrib/minizip";

  meta = {
    description = "Compression library implementing the deflate compression method found in gzip and PKZIP";
    inherit (zlib.meta) license homepage;
    platforms = lib.platforms.unix;
  };
}

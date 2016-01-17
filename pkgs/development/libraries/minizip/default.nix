{ stdenv, zlib, autoreconfHook }:

stdenv.mkDerivation {
  name = "minizip-${zlib.version}";
  inherit (zlib) src;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  sourceRoot = "zlib-${zlib.version}/contrib/minizip";
}

{ lib, stdenv, zlib, autoreconfHook }:

stdenv.mkDerivation {
  pname = "minizip";
<<<<<<< HEAD
  inherit (zlib) src version;
=======
  version = zlib.version;
  inherit (zlib) src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  sourceRoot = "zlib-${zlib.version}/contrib/minizip";

  meta = {
    description = "Compression library implementing the deflate compression method found in gzip and PKZIP";
    inherit (zlib.meta) license homepage;
    platforms = lib.platforms.unix;
  };
}

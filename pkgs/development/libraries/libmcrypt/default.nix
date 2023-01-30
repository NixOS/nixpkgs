{ lib, stdenv, fetchurl, darwin, disablePosixThreads ? false }:

stdenv.mkDerivation rec {
  pname = "libmcrypt";
  version = "2.5.8";

  src = fetchurl {
    url = "mirror://sourceforge/mcrypt/Libmcrypt/${version}/libmcrypt-${version}.tar.gz";
    sha256 = "0gipgb939vy9m66d3k8il98rvvwczyaw2ixr8yn6icds9c3nrsz4";
  };

  buildInputs = lib.optional stdenv.isDarwin darwin.cctools;

  configureFlags = lib.optionals disablePosixThreads
    [ "--disable-posix-threads" ];

  meta = {
    description = "Replacement for the old crypt() package and crypt(1) command, with extensions";
    homepage = "http://mcrypt.sourceforge.net";
    license = "GPL";
    platforms = lib.platforms.all;
  };
}

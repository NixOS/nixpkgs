{ xftSupport ? true
, xrenderSupport ? true
, threadSupport ? true
, mysqlSupport ? true
, stdenv, fetchurl, x11, libXft ? null, libXrender ? null, mysql ? null
, zlib, libjpeg, libpng, which
}:

assert xftSupport -> libXft != null;
assert xrenderSupport -> xftSupport && libXft != null;
assert mysqlSupport -> mysql != null;

stdenv.mkDerivation {
  name = "qt-3.3.3";

  builder = ./builder.sh;
  substitute = ../../../build-support/substitute/substitute.sh;
  hook = ./setup-hook.sh;  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/qt-x11-free-3.3.3.tar.bz2;
    md5 = "3e0a0c8429b0a974b39b5f535ddff01c";
  };

  buildInputs = [x11 libXft libXrender zlib libjpeg libpng which];

  # Don't strip everything so we can get useful backtraces.
  patches = [./strip.patch ./qt-pwd.patch];
  
  inherit threadSupport xftSupport libXft xrenderSupport libXrender;
  inherit mysqlSupport;
  mysql = if mysqlSupport then mysql else null;
  inherit (libXft) freetype fontconfig;
}

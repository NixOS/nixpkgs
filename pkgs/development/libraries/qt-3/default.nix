{ xftSupport ? true
, xrenderSupport ? true
, stdenv, fetchurl, x11, libXft ? null, libXrender ? null
, zlib, libjpeg, libpng, which
}:

assert xftSupport -> libXft != null;
assert xrenderSupport -> xftSupport && libXft != null;

stdenv.mkDerivation {
  name = "qt-3.3.3";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://sunsite.rediris.es/mirror/Qt/source/qt-x11-free-3.3.3.tar.bz2;
    md5 = "3e0a0c8429b0a974b39b5f535ddff01c";
  };

  buildInputs = [x11 libXft libXrender zlib libjpeg libpng which];

  inherit xftSupport libXft xrenderSupport libXrender;
  inherit (libXft) freetype fontconfig;
}

{stdenv, fetchurl, pkgconfig, libX11, libXrender, freetype, fontconfig}:

# !!! assert freetype `elem` fontconfig.buildInputs or some such
# assert freetype == fontconfig.freetype;

(stdenv.mkDerivation {
  name = "libXft-2.1.6";
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/libXft-2.1.6.tar.bz2;
    md5 = "ba10c9c3f4758f304f04f8d48e2f81a4";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11 libXrender freetype fontconfig];
}) // {inherit freetype fontconfig;}
{stdenv, fetchurl, pkgconfig, libX11, libXrender, freetype, fontconfig}:

# !!! assert freetype `elem` fontconfig.buildInputs or some such
# assert freetype == fontconfig.freetype;

(stdenv.mkDerivation {
  name = "libXft-2.1.7";
  src = fetchurl {
    url =http://xlibs.freedesktop.org/release/libXft-2.1.7.tar.bz2 ;
    md5 = "3e311b4095283d59488b95c8bd772521";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11 libXrender freetype fontconfig];
}) // {inherit freetype fontconfig;}
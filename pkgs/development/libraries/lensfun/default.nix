{ stdenv, fetchurl, pkgconfig, glib, zlib, libpng, cmake }:

stdenv.mkDerivation rec {
  version = "0.3.95";
  name = "lensfun-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/lensfun/${version}/${name}.tar.gz";
    sha256 = "0218f3xrlln0jmh4gcf1zbpvi2bidgl3b2mblf6c810n7j1rrhl2";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ glib zlib libpng ];

  configureFlags = [ "-v" ];

  meta = with stdenv.lib; {
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ enzime ];
    license = stdenv.lib.licenses.lgpl3;
    description = "An opensource database of photographic lenses and their characteristics";
    homepage = http://lensfun.sourceforge.net/;
  };
}

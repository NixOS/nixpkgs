{ stdenv, fetchurl, pkgconfig, glib, zlib, libpng, gnumake3, cmake }:

stdenv.mkDerivation rec {
  version = "0.3.2";
  name = "lensfun-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/lensfun/${version}/${name}.tar.gz";
    sha256 = "0cfk8jjhs9nbfjfdy98plrj9ayi59aph0nx6ppslgjhlcvacm2xf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib zlib libpng cmake gnumake3 ];

  configureFlags = [ "-v" ];

  meta = with stdenv.lib; {
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ enzime ];
    license = stdenv.lib.licenses.lgpl3;
    description = "An opensource database of photographic lenses and their characteristics";
    homepage = http://lensfun.sourceforge.net/;
  };
}

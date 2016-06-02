{ stdenv, fetchurl
, pkgconfig
, zlib
, libjpeg
, libpng
, libwebp
, libtiff ? null
, libXpm ? null
, fontconfig
, freetype
}:

stdenv.mkDerivation rec {
  name = "gd-${version}";
  version = "2.2.1";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/${name}/libgd-${version}.tar.xz";
    sha256 = "0xmrqka1ggqgml84xbmkw1y0r0lg7qn657v5b1my8pry92p651vh";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib fontconfig freetype libjpeg libpng libwebp libtiff libXpm ];

  outputs = [ "dev" "out" "bin" ];

  postFixup = ''moveToOutput "bin/gdlib-config" $dev'';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://libgd.github.io/;
    description = "A dynamic image creation library";
    license = licenses.free; # some custom license
    platforms = platforms.unix;
  };
}

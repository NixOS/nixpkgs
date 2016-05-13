{ stdenv, fetchurl
, pkgconfig
, zlib
, libjpeg
, libpng
, libtiff ? null
, libXpm ? null
, fontconfig
, freetype
}:

stdenv.mkDerivation rec {
  name = "gd-${version}";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/${name}/libgd-${version}.tar.xz";
    sha256 = "11djy9flzxczphigqgp7fbbblbq35gqwwhn9xfcckawlapa1xnls";
  };

  patches = [
    ./CVE-2016-3074.patch
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib fontconfig freetype libjpeg libpng libtiff libXpm ];

  meta = with stdenv.lib; {
    homepage = https://libgd.github.io/;
    description = "A dynamic image creation library";
    license = licenses.free; # some custom license
    platforms = platforms.unix;
  };
}

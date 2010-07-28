{ stdenv, fetchurl, zlib, imagemagick, libpng, pkgconfig, glib, freetype
, libjpeg, libxml2 }:

stdenv.mkDerivation {
  name = "libwmf-0.2.8.4";

  src = fetchurl {
    url = mirror://sourceforge/wvware/libwmf-0.2.8.4.tar.gz;
    sha256 = "1y3wba4q8pl7kr51212jwrsz1x6nslsx1gsjml1x0i8549lmqd2v";
  };

  buildInputs = [ zlib imagemagick libpng pkgconfig glib freetype libjpeg libxml2 ];

  meta = {
    description = "WMF library from wvWare";
  };
}

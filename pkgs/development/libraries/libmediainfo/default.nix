{ stdenv, fetchurl, automake, autoconf, libtool, pkgconfig, libzen, zlib }:

stdenv.mkDerivation rec {
  version = "0.7.72";
  name = "libmediainfo-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.bz2";
    sha256 = "1ndfag9a7yl8j1iwxgd2d8slwzc0ifmzg9zf8lg7fsqsa9c3s7m6";
  };

  buildInputs = [ automake autoconf libtool pkgconfig libzen zlib ];

  sourceRoot = "./MediaInfoLib/Project/GNU/Library/";

  configureFlags = [ "--enable-shared" ];
  preConfigure = "sh autogen";

  postInstall = ''
    install -vD -m 644 libmediainfo.pc "$out/lib/pkgconfig/libmediainfo.pc"
  '';

  meta = {
    description = "Shared library for mediainfo";
    homepage = http://mediaarea.net/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}

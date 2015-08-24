{ stdenv, fetchurl, automake, autoconf, libtool, pkgconfig, libzen, zlib }:

stdenv.mkDerivation rec {
  version = "0.7.76";
  name = "libmediainfo-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.xz";
    sha256 = "088hxj3x12ww8zym3g6izz1w9m6wxgdy7hc2m089cd4sv9dlccnq";
  };

  buildInputs = [ automake autoconf libtool pkgconfig libzen zlib ];

  sourceRoot = "./MediaInfoLib/Project/GNU/Library/";

  configureFlags = [ "--enable-shared" ];
  preConfigure = "sh autogen.sh";

  postInstall = ''
    install -vD -m 644 libmediainfo.pc "$out/lib/pkgconfig/libmediainfo.pc"
  '';

  meta = {
    description = "Shared library for mediainfo";
    homepage = http://mediaarea.net/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}

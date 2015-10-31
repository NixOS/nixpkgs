{ stdenv, fetchurl, automake, autoconf, libtool, pkgconfig, libzen, zlib }:

stdenv.mkDerivation rec {
  version = "0.7.78";
  name = "libmediainfo-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.xz";
    sha256 = "0ai4al5h3qbfq5f1b24ixk5v1fpln2kw1zmdj4hxjz40rj18qzka";
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

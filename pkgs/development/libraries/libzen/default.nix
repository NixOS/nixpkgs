{ stdenv, fetchurl, automake, autoconf, libtool, pkgconfig }:

let version = "0.4.32"; in

stdenv.mkDerivation {
  name = "libzen-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/libzen/${version}/libzen_${version}.tar.bz2";
    sha256 = "0rhbiaywij6jj8d7vkc4v7y21ic1kv9fbn9lk82mm12yjwzlhhyd";
  };

  buildInputs = [ automake autoconf libtool pkgconfig ];
  configureFlags = [ "--enable-shared" ];

  sourceRoot = "./ZenLib/Project/GNU/Library/";

  preConfigure = "sh autogen.sh";

  meta = {
    description = "Shared library for libmediainfo and mediainfo";
    homepage = http://mediaarea.net/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}

{stdenv, fetchurl, php, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "php-xcache-1.3.1";
  
  src = fetchurl {
    url = http://xcache.lighttpd.net/pub/Releases/1.3.1/xcache-1.3.1.tar.bz2;
    sha256 = "16qj6hns7frs655k2vg9dabnk28085hf6qxhr9dybw6ja5aj24g3";
  };

  preConfigure = ''
    phpize

    sed -i 's,^EXTENSION_DIR.*,'EXTENSION_DIR=$out/lib/php/extensions, configure
  '';

/*
  configureFlags = [ "--enable-apc" "--enable-apc-mmap" ];
*/

  buildInputs = [ php autoconf automake libtool ];

  meta = {
    description = "Fast, stable PHP opcode cacher";
    homepage = http://xcache.lighttpd.net/;
    license = "BSD";
  };
}

{stdenv, fetchurl, php, autoconf, automake, libtool, m4 }:

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

  configureFlags = [
    "--enable-xcache" 
    "--enable-xcache-coverager" 
    "--enable-xcache-optimizer" 
    "--enable-xcache-assembler"
    "--enable-xcache-encoder"
    "--enable-xcache-decoder"
  ];

  buildInputs = [ php autoconf automake libtool m4 ];

  meta = {
    description = "Fast, stable PHP opcode cacher";
    homepage = http://xcache.lighttpd.net/;
    license = "BSD";
  };
}

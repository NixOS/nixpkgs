{stdenv, fetchurl, php, autoconf, automake, libtool, m4 }:

stdenv.mkDerivation rec {
  name = "php-xcache-3.0.1";
  
  src = fetchurl {
    url = http://xcache.lighttpd.net/pub/Releases/3.0.1/xcache-3.0.1.tar.bz2;
    md5 = "45086010bc4f82f506c08be1c556941b";
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

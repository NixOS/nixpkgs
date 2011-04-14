{stdenv, fetchurl, php, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "php-apc-3.1.7";
  
  src = fetchurl {
    url = http://pecl.php.net/get/APC-3.1.7.tgz;
    sha256 = "0xlvhw5398sl5zzkjm4rkk1m3fcra30zkq0k4i6fij0ylpd6nlls";
  };

  preConfigure = ''
    phpize

    sed -i 's,^EXTENSION_DIR.*,'EXTENSION_DIR=$out/lib/php/extensions, configure
  '';

  configureFlags = [ "--enable-apc" "--enable-apc-mmap" ];

  buildInputs = [ php autoconf automake libtool ];

  meta = {
    description = "Alternative PHP Cache";
    homepage = "http://pecl.php.net/package/APC";
    license = "PHP+";
  };
}

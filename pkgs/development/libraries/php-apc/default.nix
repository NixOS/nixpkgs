{stdenv, fetchurl, php, autoconf, automake, libtool
, version ? "3.1.9" }:

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "php-apc" version {
  "3.1.9" = {
    name = "php-apc-3.1.9";
    src = fetchurl {
      url = http://pecl.php.net/get/APC-3.1.9.tgz;
      sha256 = "0wfnhaj7qzfx1c0svv7b73k4py8ccvb3v6qw3r96h6nsv4cg3pj7";
    };
  };
  "3.1.7" = {
    name = "php-apc-3.1.7";
    src = fetchurl {
      url = http://pecl.php.net/get/APC-3.1.7.tgz;
      sha256 = "0xlvhw5398sl5zzkjm4rkk1m3fcra30zkq0k4i6fij0ylpd6nlls";
    };
  };
 }
 ( rec {

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
}))

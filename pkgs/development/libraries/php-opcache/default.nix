{stdenv, pkgs, fetchgit, php5_4, autoconf, automake, libtool, m4 }:

stdenv.mkDerivation rec {
  name = "php-opcache-7.0.2";
  
  src = fetchgit {
    url = https://github.com/zendtech/ZendOptimizerPlus.git;
    rev = "20971cd33d723f2be1b9e2bd5bf0c5ad07c4af81";
    sha256 = "0lpfa4kdpz4f528jwydif6gn6kinv457dmkrjmp1szdsvpf3dlfy";
  };

  preConfigure = ''
    phpize

    sed -i 's,^EXTENSION_DIR.*,'EXTENSION_DIR=$out/lib/php/extensions, configure
  '';

  configureFlags = [
    "--with-php-config=${pkgs.php5_4}/bin/php-config"
  ];

  buildInputs = [ php5_4 autoconf automake libtool m4 ];

  meta = {
    description = "The Zend OPcache provides faster PHP execution through opcode caching and optimization.";
    homepage = http://pecl.php.net/package/ZendOpcache;
    license = "PHP";
  };
}

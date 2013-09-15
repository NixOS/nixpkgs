{ stdenv, fetchurl, php, autoconf, automake }:

stdenv.mkDerivation rec {
  version = "2.2.3";
  name = "php-xdebug-${version}";

  src = fetchurl {
    url = "http://xdebug.org/files/xdebug-2.2.3.tgz";
    sha256 = "076px4ax3qcqr3mmhi9jjkfhn7pcymrpda4hzy6kgn3flhnqfldk";
  };

  buildInputs = [ php autoconf automake ];

  configurePhase = ''
    phpize
    ./configure --prefix=$out
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # looks for this file for some reason -- isn't needed
    touch unix.h
  '';

  buildPhase = ''
    make && make test
  '';

  installPhase = ''
    mkdir -p $out/lib/xdebug
    cp modules/xdebug.so $out/lib
    cp LICENSE $out/lib/xdebug
  '';

  meta = {
    description = "PHP debugger and profiler extension";
    homepage = http://xdebug.org/;
    license = "xdebug"; # based on PHP-3
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}

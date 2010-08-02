{ stdenv, fetchurl, php, autoconf, automake }:

stdenv.mkDerivation {
  name = "php-xdebug-2.0.5";

  src = fetchurl {
    url = "http://xdebug.org/files/xdebug-2.0.5.tgz";
    sha256 = "1cmq7c36gj8n41mfq1wba5rij8j77yqhydpcsbcysk1zchg68f26";
  };

  buildInputs = [ php autoconf automake ];

  configurePhase = ''
    phpize
    ./configure --prefix=$out
  '';

  buildPhase = ''
    make && make test
  '';

  installPhase = ''
    ensureDir $out/lib/xdebug
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

{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation {
  name = "boolstuff-0.1.12";

  src = fetchurl {
    url = http://perso.b2b2c.ca/sarrazip/dev/boolstuff-0.1.12.tar.gz;
    sha256 = "0h39civar6fjswaf3bn1r2ddj589rya0prd6gzsyv3qzr9srprq9";
  };

  buildInputs = [ pkgconfig ];

  meta = { 
    description = "Library for operations on boolean expression binary trees";
    homepage = http://perso.b2b2c.ca/sarrazip/dev/boolstuff.html;
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}

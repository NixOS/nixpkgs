{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "freetype-2.3.5";
  
  src = fetchurl {
    url = mirror://sourceforge/freetype/freetype-2.3.5.tar.bz2;
    sha256 = "0zk73lj0rrq4ahg4lfh6qzgs7agsqda3hpnjvy08riq624x7ld8v";
  };

  meta = {
    description = "A font engine";
    homepage = http://www.freetype.org/;
  };
}

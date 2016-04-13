{ stdenv, fetchurl, perl, icu, zlib, gmp, readline }:

stdenv.mkDerivation rec {
  name = "rakudo-star-${version}";
  version = "2016.01";

  src = fetchurl {
    url    = "http://rakudo.org/downloads/star/${name}.tar.gz";
    sha256 = "feb385c5d05166061f413882e442d3a0ec53884918768940d3f00bb63bc85497";
  };

  buildInputs = [ icu zlib gmp readline perl ];
  configureScript = "perl ./Configure.pl";
  configureFlags =
    [ "--backends=moar"
      "--gen-moar"
      "--gen-nqp"
    ];

  meta = {
    description = "A Perl 6 implementation";
    homepage    = "http://www.rakudo.org";
    license     = stdenv.lib.licenses.artistic2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}

{ stdenv, fetchurl, perl, jdk, icu, zlib, gmp, readline }:

stdenv.mkDerivation rec {
  name = "rakudo-star-${version}";
  version = "2014.04";

  src = fetchurl {
    url    = "http://rakudo.org/downloads/star/${name}.tar.gz";
    sha256 = "0spdrxc2kiidpgni1vl71brgs4d76h8029w5jxvah3yvjcqixz7l";
  };

  buildInputs = [ icu zlib gmp readline jdk perl ];
  configureScript = "perl ./Configure.pl";
  configureFlags =
    [ "--gen-moar"
      "--gen-nqp"
      "--gen-parrot"
    ];

  meta = {
    description = "A Perl 6 implementation";
    homepage    = "http://www.rakudo.org";
    license     = stdenv.lib.licenses.artistic2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}

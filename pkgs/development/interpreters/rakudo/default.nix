{ stdenv, fetchurl, perl, icu, zlib, gmp, readline }:

stdenv.mkDerivation rec {
  name = "rakudo-star-${version}";
  version = "2016.04";

  src = fetchurl {
    url    = "http://rakudo.org/downloads/star/${name}.tar.gz";
    sha256 = "11xzgwy155xpagrn3gzg8vqnqgjxwar70a3gzzmc9sica5064pva";
  };

  buildInputs = [ icu zlib gmp readline perl ];
  configureScript = "perl ./Configure.pl";
  configureFlags =
    [ "--backends=moar"
      "--gen-moar"
      "--gen-nqp"
    ];

  meta = with stdenv.lib; {
    description = "A Perl 6 implementation";
    homepage    = "http://www.rakudo.org";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}

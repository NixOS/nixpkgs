{ stdenv, fetchurl, perl, jdk, icu, zlib, gmp, readline }:

stdenv.mkDerivation rec {
  name = "rakudo-star-${version}";
  version = "2015.03";

  src = fetchurl {
    url    = "http://rakudo.org/downloads/star/${name}.tar.gz";
    sha256 = "1fwvmjyc1bv3kq7p25xyl4sqinp19mbrspmf0h7rvxlwnfcrr5mv";
  };

  buildInputs = [ icu zlib gmp readline jdk perl ];
  configureScript = "perl ./Configure.pl";
  configureFlags =
    [ "--backends=moar,jvm"
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

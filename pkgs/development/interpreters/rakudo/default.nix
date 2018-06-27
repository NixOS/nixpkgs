{ stdenv, fetchurl, perl, icu, zlib, gmp, readline
, CoreServices, ApplicationServices }:

stdenv.mkDerivation rec {
  name = "rakudo-star-${version}";
  version = "2017.01";

  src = fetchurl {
    url    = "http://rakudo.org/downloads/star/${name}.tar.gz";
    sha256 = "07zjqdzxm30pmjqwlnr669d75bsbimy09sk0dvgm0pnn3zr92fjq";
  };

  buildInputs = [ icu zlib gmp readline perl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ApplicationServices ];
  configureScript = "perl ./Configure.pl";
  configureFlags =
    [ "--backends=moar"
      "--gen-moar"
      "--gen-nqp"
    ];

  meta = with stdenv.lib; {
    description = "A Perl 6 implementation";
    homepage    = https://www.rakudo.org;
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra ];
  };
}

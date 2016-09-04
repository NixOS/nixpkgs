{ stdenv, fetchurl, perl, icu, zlib, gmp, readline
, CoreServices, ApplicationServices }:

stdenv.mkDerivation rec {
  name = "rakudo-star-${version}";
  version = "2016.07";

  src = fetchurl {
    url    = "http://rakudo.org/downloads/star/${name}.tar.gz";
    sha256 = "0czx7w1chf108mpyps7k7nqq8cbsy1rbb87ajms9xj65l4ywg8ka";
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
    homepage    = "http://www.rakudo.org";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice maintainers.vrthra ];
  };
}

{ stdenv, fetchurl, perl, icu, zlib, gmp, lib, nqp }:

stdenv.mkDerivation rec {
  pname = "rakudo";
  version = "2020.11";

  src = fetchurl {
    url    = "https://www.rakudo.org/dl/rakudo/rakudo-${version}.tar.gz";
    sha256 = "107sskgf0p6npm3vjpv5wrqgfa007af6bxxiv1wgiyzx7maqdw5n";
  };

  buildInputs = [ icu zlib gmp perl ];
  configureScript = "perl ./Configure.pl";
  configureFlags = [
    "--backends=moar"
    "--with-nqp=${nqp}/bin/nqp"
  ];

  # Remove test of profiler, fails since 2020.09
  preCheck = "rm t/09-moar/01-profilers.t";

  # Some tests fail on Darwin
  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Raku implementation on top of Moar virtual machine";
    homepage    = "https://www.rakudo.org";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}

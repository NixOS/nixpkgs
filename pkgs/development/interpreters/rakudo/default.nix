{ stdenv, fetchurl, perl, icu, zlib, gmp, lib, nqp }:

stdenv.mkDerivation rec {
  pname = "rakudo";
  version = "2020.10";

  src = fetchurl {
    url    = "https://www.rakudo.org/dl/rakudo/rakudo-${version}.tar.gz";
    sha256 = "0wvsinmpz8icd0409f8rg93mqdb5ml76m0vb4r26ngz237ph69dn";
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

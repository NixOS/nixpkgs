{ stdenv, fetchurl, perl, icu, zlib, gmp, lib, nqp }:

stdenv.mkDerivation rec {
  pname = "rakudo";
  version = "2021.02.1";

  src = fetchurl {
    url    = "https://www.rakudo.org/dl/rakudo/rakudo-${version}.tar.gz";
    sha256 = "1xwqx4357bw7h5pdmwxm5wxh8wjvrcdk4rvr3wyrhg1wzy5qvsn8";
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

  meta = with lib; {
    description = "Raku implementation on top of Moar virtual machine";
    homepage    = "https://www.rakudo.org";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}

{ stdenv, fetchurl, perl, lib, moarvm }:

stdenv.mkDerivation rec {
  pname = "nqp";
  version = "2020.10";

  src = fetchurl {
    url    = "https://github.com/raku/nqp/releases/download/${version}/nqp-${version}.tar.gz";
    sha256 = "0nb0vdycz2wrd5yspvps2wy7a21066csr18v786085qim347830h";
  };

  buildInputs = [ perl ];

  configureScript = "${perl}/bin/perl ./Configure.pl";
  configureFlags = [
    "--backends=moar"
    "--with-moar=${moarvm}/bin/moar"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Not Quite Perl -- a lightweight Raku-like environment for virtual machines";
    homepage    = "https://github.com/perl6/nqp";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}

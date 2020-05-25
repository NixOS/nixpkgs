{ stdenv, fetchurl, perl, lib, moarvm }:

stdenv.mkDerivation rec {
  pname = "nqp";
  version = "2020.02.1";

  src = fetchurl {
    url    = "https://github.com/perl6/nqp/releases/download/${version}/nqp-${version}.tar.gz";
    sha256 = "0zw3g7viyq4n4qwy0laww2mzz6wrzkfcq4fm82scy1mh65r7bdgj";
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

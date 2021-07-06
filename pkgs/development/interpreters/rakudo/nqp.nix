{ stdenv, fetchurl, perl, lib, moarvm }:

stdenv.mkDerivation rec {
  pname = "nqp";
  version = "2021.06";

  src = fetchurl {
    url    = "https://github.com/raku/nqp/releases/download/${version}/nqp-${version}.tar.gz";
    sha256 = "1d00lajjdd2k510fb0cb6c8bpklvlnncykf6jz8j8djfp0b2i696";
  };

  buildInputs = [ perl ];

  configureScript = "${perl}/bin/perl ./Configure.pl";
  configureFlags = [
    "--backends=moar"
    "--with-moar=${moarvm}/bin/moar"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Not Quite Perl -- a lightweight Raku-like environment for virtual machines";
    homepage    = "https://github.com/perl6/nqp";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}

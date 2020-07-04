{ stdenv, fetchurl, perl, lib, moarvm }:

stdenv.mkDerivation rec {
  pname = "nqp";
  version = "2020.06";

  src = fetchurl {
    url    = "https://github.com/perl6/nqp/releases/download/${version}/nqp-${version}.tar.gz";
    sha256 = "13wkhdxxs86wl6ahfzhyp45dy6hk6qnij3dm8d8893b2rxs377m4";
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

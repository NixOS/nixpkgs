{ stdenv, fetchurl, perl
, CoreServices, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "moarvm";
  version = "2020.08";

  src = fetchurl {
    url = "https://www.moarvm.org/releases/MoarVM-${version}.tar.gz";
    sha256 = "1gq7z4z5lnkai01721waawkkal82sdmyra05nnbfb1986mq5xpiy";
   };

  buildInputs = [ perl ] ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ApplicationServices ];
  doCheck = false; # MoarVM does not come with its own test suite

  configureScript = "${perl}/bin/perl ./Configure.pl";

  meta = with stdenv.lib; {
    description = "VM with adaptive optimization and JIT compilation, built for Rakudo";
    homepage    = "https://www.moarvm.org/";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}

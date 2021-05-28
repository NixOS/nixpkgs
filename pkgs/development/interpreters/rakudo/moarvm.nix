{ stdenv, fetchurl, perl
, CoreServices, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "moarvm";
  version = "2020.09";

  src = fetchurl {
    url = "https://www.moarvm.org/releases/MoarVM-${version}.tar.gz";
    sha256 = "08prlvnyqwnzb7mwaqvgv662v78xgwsyy12cpyim6gc4z0i1kcj8";
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

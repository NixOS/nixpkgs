{ lib, stdenv, fetchurl, perl
, CoreServices, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "moarvm";
  version = "2021.06";

  src = fetchurl {
    url = "https://moarvm.org/releases/MoarVM-${version}.tar.gz";
    sha256 = "19vjcyb9fg9msjw1ih00c2qby480gl4highw24zx7j84slhsj013";
   };

  buildInputs = [ perl ] ++ lib.optionals stdenv.isDarwin [ CoreServices ApplicationServices ];
  doCheck = false; # MoarVM does not come with its own test suite

  configureScript = "${perl}/bin/perl ./Configure.pl";

  meta = with lib; {
    description = "VM with adaptive optimization and JIT compilation, built for Rakudo";
    homepage    = "https://moarvm.org";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}

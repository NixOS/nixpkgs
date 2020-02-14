{ stdenv, fetchurl, perl
, CoreServices, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "moarvm";
  version = "2020.01.1";

  src = fetchurl {
    url    = "https://github.com/MoarVM/MoarVM/releases/download/${version}/MoarVM-${version}.tar.gz";
    sha256 = "11rmlps6r3nqa9m2yyv9i2imahirsqmxbfay71f3gs4ql121xdnw";
  };

  buildInputs = [ perl ] ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices ApplicationServices ];
  doCheck = false; # MoarVM does not come with its own test suite

  configureScript = "${perl}/bin/perl ./Configure.pl";

  meta = with stdenv.lib; {
    description = "VM with adaptive optimization and JIT compilation, built for Rakudo";
    homepage    = "https://github.com/MoarVM/MoarVM";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}

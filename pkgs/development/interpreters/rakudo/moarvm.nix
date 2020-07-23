{ stdenv, fetchurl, perl
, CoreServices, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "moarvm";
  version = "2020.07";

  src = fetchurl {
    url = "https://www.moarvm.org/releases/MoarVM-${version}.tar.gz";
    sha256 = "1kzp76vqvny8gpp0b4xg1hg4vih4gmic4w1lddc9gqz03dx8hj6s";
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

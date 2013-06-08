{ stdenv, fetchurl }:
stdenv.mkDerivation {
  name = "libestr-0.1.4";
  src = fetchurl {
    url = http://libestr.adiscon.com/files/download/libestr-0.1.4.tar.gz;
    sha256 = "1qw5vqryawdm434l9ql3r160ap2f5mmp7b6pciac7qli62y0a2z3";
  };
}

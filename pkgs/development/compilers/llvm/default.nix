{stdenv, fetchurl, gcc, flex, perl, libtool }:

stdenv.mkDerivation {
  name = "llvm-2.2";
  src = fetchurl {
    url    = http://llvm.org/releases/2.2/llvm-2.2.tar.gz;
    sha256 = "788d871aec139e0c61d49533d0252b21c4cd030e91405491ee8cb9b2d0311072";
  };

  buildInputs = [ gcc flex perl libtool ];
}

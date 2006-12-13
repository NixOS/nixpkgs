{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.4.2y";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/aterm-2.4.2.tar.gz;
    md5 = "18617081dd112d85e6c4b1b552628114";
  };
  patches = 
    [./aterm-alias-fix-2.patch] ++
    (if stdenv ? isMinGW && stdenv.isMinGW then [./mingw-asm.patch] else []);
  meta = {
    homepage = http://www.cwi.nl/htbin/sen1/twiki/bin/view/SEN1/ATerm;
    license = "LGPL";
    description = "Library for manipulation of term data structures in C";
  };
#  unpackPhase = "while true; do sleep 4; echo x; done";
#  unpackPhase = "sleep 10000";
   unpackPhase = "mkdir $out; echo foo > $out/foo; ln -s foo $out/bar; exit 0";
}

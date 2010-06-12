{stdenv, fetchurl, gcc, flex, perl, libtool, groff }:

stdenv.mkDerivation {
  name = "llvm-2.7";
  src = fetchurl {
    url    = http://llvm.org/releases/2.7/llvm-2.7.tgz;
    sha256 = "19dwvfyxr851fjfsaxbm56gdj9mlivr37bv6h41hd8q3hpf4nrlr";
  };

  buildInputs = [ gcc flex perl libtool groff ];
}

{ stdenv, fetchurl, perl, groff, cmake, python }:

let version = "3.2"; in

stdenv.mkDerivation {
  name = "llvm-${version}";

  src = fetchurl {
    url    = "http://llvm.org/releases/${version}/llvm-${version}.src.tar.gz";
    sha256 = "0hv30v5l4fkgyijs56sr1pbrlzgd674pg143x7az2h37sb290l0j";
  };

  buildInputs = [ perl groff cmake python ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://llvm.org/;
    description = "Collection of modular and reusable compiler and toolchain technologies";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric shlevy raskin];
    platforms = with stdenv.lib.platforms; all;
  };
}

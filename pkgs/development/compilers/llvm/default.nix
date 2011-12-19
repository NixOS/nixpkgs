{ stdenv, fetchurl, perl, groff, darwinSwVersUtility, cmake }:

let version = "3.0"; in

stdenv.mkDerivation {
  name = "llvm-${version}";

  src = fetchurl {
    url    = "http://llvm.org/releases/${version}/llvm-${version}.tar.gz";
    sha256 = "0xq4gi7lflv8ilfckslhfvnja5693xjii1yvzz39kklr6hfv37ji";
  };

  buildInputs = [ perl groff cmake ] ++
    stdenv.lib.optional stdenv.isDarwin darwinSwVersUtility;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://llvm.org/;
    description = "Collection of modular and reusable compiler and toolchain technologies";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric shlevy];
    platforms = with stdenv.lib.platforms; linux;
  };
}


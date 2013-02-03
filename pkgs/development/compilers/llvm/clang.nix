{ stdenv, fetchurl, perl, groff, llvm, cmake, libxml2 }:

let version = "3.2"; in

stdenv.mkDerivation {
  name = "clang-${version}";

  buildInputs = [ perl llvm groff cmake libxml2 ];

  patches = stdenv.lib.optional (stdenv.gcc.libc != null) ./clang-purity.patch;

  cmakeFlags = [
    "-DCLANG_PATH_TO_LLVM_BUILD=${llvm}"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_TARGETS_TO_BUILD=all"
  ] ++ stdenv.lib.optionals (stdenv.gcc.libc != null) [
    "-DC_INCLUDE_DIRS=${stdenv.gcc.libc}/include/"
  ];

  enableParallelBuilding = true;

  src = fetchurl {
      url = "http://llvm.org/releases/${version}/clang-${version}.src.tar.gz";
      sha256 = "0n2nzw3pw2v7fk67f2k2qyzd9wibvi3i5j7cjzz1csqgghzz1aia";
  };

  passthru = { gcc = stdenv.gcc.gcc; };

  meta = {
    homepage = http://clang.llvm.org/;
    description = "A C language family frontend for LLVM";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric shlevy];
    platforms = with stdenv.lib.platforms; all;
  };
}

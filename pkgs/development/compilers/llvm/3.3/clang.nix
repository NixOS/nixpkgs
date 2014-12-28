{ stdenv, fetchurl, perl, groff, llvm, cmake, libxml2, python }:

let
  version = "3.3";
  gccReal = if (stdenv.cc.gcc or null) == null then stdenv.cc else stdenv.cc.gcc;
in

stdenv.mkDerivation {
  name = "clang-${version}";

  buildInputs = [ perl llvm groff cmake libxml2 python ];

  patches = [ ./clang-tablegen-dir.patch ] ++
            stdenv.lib.optional (stdenv.cc.libc != null) ./clang-purity.patch;

  cmakeFlags = [
    "-DCLANG_PATH_TO_LLVM_BUILD=${llvm}"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_TARGETS_TO_BUILD=all"
    "-DGCC_INSTALL_PREFIX=${gccReal}"
  ] ++ stdenv.lib.optionals (stdenv.cc.libc != null) [
    "-DC_INCLUDE_DIRS=${stdenv.cc.libc}/include/"
  ];

  enableParallelBuilding = true;

  src = fetchurl {
      url = "http://llvm.org/releases/${version}/cfe-${version}.src.tar.gz";
      sha256 = "15mrvw43s4frk1j49qr4v5viq68h8qlf10qs6ghd6mrsmgj5vddi";
  };

  passthru = { gcc = stdenv.cc.gcc; };

  meta = {
    homepage = http://clang.llvm.org/;
    description = "A C language family frontend for LLVM";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}

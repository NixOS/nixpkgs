{ stdenv, fetchurl, perl, groff, llvm, cmake }:

let version = "3.1"; in

stdenv.mkDerivation {
  name = "clang-${version}";

  buildInputs = [ perl llvm groff cmake ];

  patches = stdenv.lib.optionals (stdenv.gcc.libc != null) 
    [ ./clang-include-paths.patch ./clang-ld-flags.patch ];

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
      sha256 = "11m7sm9f8qcrayckfg3z91zb3fimilpm0f7azn7q7qnkvhay4qzz";
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


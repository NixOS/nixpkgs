{ stdenv, cmake, fetch, llvm, version }:

stdenv.mkDerivation {
  name = "llvm-libunwind-${version}";

  src = fetch "libunwind" "1ys9z41nr1l3k6vj0mas1qz24bd5fa9kggkapv4d7rf2ad9497xn";

  buildInputs = [ cmake llvm ];
  cmakeFlags = "-DLIBUNWIND_ENABLE_SHARED=0";

  meta = {
    homepage = http://libcxxabi.llvm.org/;
    description = "LLVM libunwind implementation";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ globin ];
    platforms = stdenv.lib.platforms.unix;
  };
}

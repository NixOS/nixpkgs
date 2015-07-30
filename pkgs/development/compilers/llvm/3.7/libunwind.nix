{ stdenv, cmake, fetch, llvm, version }:

stdenv.mkDerivation {
  name = "llvm-libunwind-${version}";

  src = fetch "libunwind" "0nyar9xs42jlxhzxdapicpmr031aa89gsbccmwglm9gkp4q0yq3a";

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

{ stdenv, fetchurl, perl, groff, llvm, cmake }:

let version = "3.0"; in

stdenv.mkDerivation {
  name = "clang-${version}";

  buildInputs = [ perl llvm groff cmake ];

  patches = stdenv.lib.optionals (stdenv.gcc.libc != null) 
    [ ./clang-include-paths.patch ./clang-ld-flags.patch ];

  postPatch = stdenv.lib.optionalString (stdenv.gcc.libc != null) ''
    sed -i -e 's,C_INCLUDE_PATH,"${stdenv.gcc.libc}/include/",' \
      -e 's,CPP_HOST,"'$(${stdenv.gcc}/bin/cc -dumpmachine)'",' \
      -e 's,CPP_INCLUDE_PATH,"${stdenv.gcc.gcc}/include/c++/${stdenv.gcc.gcc.version}",' \
      lib/Driver/ToolChains.cpp
  '';

  cmakeFlags = [ "-DCLANG_PATH_TO_LLVM_BUILD=${llvm}" "-DCMAKE_BUILD_TYPE=Release" ];

  enableParallelBuilding = true;

  src = fetchurl {
      url = "http://llvm.org/releases/${version}/clang-${version}.tar.gz";
      sha256 = "0v8j9rgmb7w74ihc44zfxa22q17c946n5b6prwl38z3d6pd74kmn";
  };

  passthru = { gcc = stdenv.gcc.gcc; };

  meta = {
    homepage = http://clang.llvm.org/;
    description = "A C language family frontend for LLVM";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric shlevy];
    platforms = with stdenv.lib.platforms; linux;
  };
}


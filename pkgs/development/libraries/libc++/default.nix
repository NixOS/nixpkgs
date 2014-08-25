{ stdenv, fetchurl, fetchsvn, cmake, libcxxabi, python }:

let
  version = "3.4.2";

in stdenv.mkDerivation rec {
  name = "libc++-${version}";

  src = fetchurl {
    url = "http://llvm.org/releases/${version}/libcxx-${version}.src.tar.gz";
    sha256 = "0z3jdvgcq995khkpis5c5vaxhbmvbqjlalbhn09k6pgb5zp46rc2";
  };

  buildInputs = [ cmake libcxxabi python ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release"
                 "-DLIBCXX_LIBCXXABI_INCLUDE_PATHS=${libcxxabi}/include"
                 "-DLIBCXX_CXX_ABI=libcxxabi" ];

  enableParallelBuilding = true;

  passthru.abi = libcxxabi;

  meta = {
    homepage = http://libcxx.llvm.org/;
    description = "A new implementation of the C++ standard library, targeting C++11";
    license = "BSD";
    maintainers = stdenv.lib.maintainers.shlevy;
    platforms = stdenv.lib.platforms.linux;
  };
}

{ stdenv, fetchurl, fetchsvn, cmake, libcxxabi, python }:

let
  version = "3.4";

in stdenv.mkDerivation rec {
  name = "libc++-${version}";

  src = fetchurl {
    url = "http://llvm.org/releases/${version}/libcxx-${version}.src.tar.gz";
    sha256 = "1sqd5qhqj7qnn9zjxx9bv7ky4f7xgmh9sbgd53y1kszhg41217xx";
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
    platforms = stdenv.lib.platforms.all;
  };
}

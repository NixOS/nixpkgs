{ lib, stdenv, fetchurl, cmake, libcxxabi, fixDarwinDylibNames }:

let version = "3.4.2"; in

stdenv.mkDerivation rec {
  name = "libc++-${version}";

  src = fetchurl {
    url = "http://llvm.org/releases/${version}/libcxx-${version}.src.tar.gz";
    sha256 = "0z3jdvgcq995khkpis5c5vaxhbmvbqjlalbhn09k6pgb5zp46rc2";
  };

  patches = [ ./darwin.patch ];

  buildInputs = [ cmake libcxxabi ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  cmakeFlags =
    [ "-DCMAKE_BUILD_TYPE=Release"
      "-DLIBCXX_LIBCXXABI_INCLUDE_PATHS=${libcxxabi}/include"
      "-DLIBCXX_LIBCXXABI_LIB_PATH=${libcxxabi}/lib"
      "-DLIBCXX_LIBCPPABI_VERSION=2"
      "-DLIBCXX_CXX_ABI=libcxxabi"
    ];

  enableParallelBuilding = true;

  inherit libcxxabi;

  # Remove a Makefile that causes many retained dependencies.
  postInstall = "rm $out/include/c++/v1/Makefile";

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = http://libcxx.llvm.org/;
    description = "A new implementation of the C++ standard library, targeting C++11";
    license = "BSD";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.unix;
  };
}

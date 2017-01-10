{ lib, stdenv, fetch, cmake, libcxxabi, fixDarwinDylibNames, version }:

stdenv.mkDerivation rec {
  name = "libc++-${version}";

  src = fetch "libcxx" "1kmyvzq06fd7zcxqvmsvym4cq6q7yl0dsbkfav8cg9v9rpvqfx0x";

  postUnpack = ''
    unpackFile ${libcxxabi.src}
    chmod -R u+w libcxxabi-*
    mv libcxxabi-* libcxxabi
    libcxxabiPath=$PWD/libcxxabi
  '';

  preConfigure = ''
    # Get headers from the cxxabi source so we can see private headers not installed by the cxxabi package
    cmakeFlagsArray=($cmakeFlagsArray -DLIBCXX_CXX_ABI_INCLUDE_PATHS="$libcxxabiPath/include")
  '';

  patches = lib.optional stdenv.isDarwin ./darwin.patch;

  buildInputs = [ cmake libcxxabi ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  cmakeFlags = [
      "-DLIBCXX_LIBCXXABI_LIB_PATH=${libcxxabi}/lib"
      "-DLIBCXX_LIBCPPABI_VERSION=2"
      "-DLIBCXX_CXX_ABI=libcxxabi"
    ];

  enableParallelBuilding = true;

  linkCxxAbi = stdenv.isLinux;

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = http://libcxx.llvm.org/;
    description = "A new implementation of the C++ standard library, targeting C++11";
    license = "BSD";
    platforms = stdenv.lib.platforms.unix;
  };
}

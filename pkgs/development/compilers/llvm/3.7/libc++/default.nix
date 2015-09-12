{ lib, stdenv, fetch, cmake, libcxxabi, fixDarwinDylibNames, version }:

stdenv.mkDerivation rec {
  name = "libc++-${version}";

  src = fetch "libcxx" "13nh78zp5d2jf732mxnalw679zjywbjpz9942j66fznd6f1kr3y1";

  postUnpack = ''
    unpackFile ${libcxxabi.src}
  '';

  preConfigure = ''
    # Get headers from the cxxabi source so we can see private headers not installed by the cxxabi package
    cmakeFlagsArray=($cmakeFlagsArray -DLIBCXX_CXX_ABI_INCLUDE_PATHS="$NIX_BUILD_TOP/libcxxabi-${version}.src/include")
  '' +
  stdenv.lib.optionalString stdenv.isDarwin ''
    # instead of allowing libc++ to link with /usr/lib/libc++abi.dylib,
    # force it to link with our copy
    substituteInPlace lib/CMakeLists.txt \
      --replace 'OSX_RE_EXPORT_LINE "/usr/lib/libc++abi.dylib' \
                'OSX_RE_EXPORT_LINE "${libcxxabi}/lib/libc++abi.dylib' \
      --replace '"''${CMAKE_OSX_SYSROOT}/usr/lib/libc++abi.dylib"' \
                '"${libcxxabi}/lib/libc++abi.dylib"'
  '';

  patches = [ ./darwin.patch ];

  buildInputs = [ cmake libcxxabi ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  cmakeFlags =
    [ "-DCMAKE_BUILD_TYPE=Release"
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

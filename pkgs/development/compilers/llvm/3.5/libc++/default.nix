{ lib, stdenv, fetchurl, cmake, libcxxabi, fixDarwinDylibNames }:

let version = "3.5.2"; in

stdenv.mkDerivation {
  pname = "libc++";
  inherit version;

  src = fetchurl {
    url = "http://llvm.org/releases/${version}/libcxx-${version}.src.tar.xz";
    sha256 = "0irnl54fwzh2hzn9x4jfvnfyq5kd0zn0iwbzdivgwhqzw6fjdwdv";
  };

  # instead of allowing libc++ to link with /usr/lib/libc++abi.dylib,
  # force it to link with our copy
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace lib/CMakeLists.txt \
      --replace 'OSX_RE_EXPORT_LINE "/usr/lib/libc++abi.dylib' \
                'OSX_RE_EXPORT_LINE "${libcxxabi}/lib/libc++abi.dylib' \
      --replace '"''${CMAKE_OSX_SYSROOT}/usr/lib/libc++abi.dylib"' \
                '"${libcxxabi}/lib/libc++abi.dylib"'
  '';

  patches = [
    ./darwin.patch
    # glibc 2.26 fix
    ./xlocale-glibc-2.26.patch
  ];

  buildInputs = [ cmake libcxxabi ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  cmakeFlags = [
    "-DLIBCXX_LIBCXXABI_INCLUDE_PATHS=${libcxxabi}/include"
    "-DLIBCXX_LIBCXXABI_LIB_PATH=${libcxxabi}/lib"
    "-DLIBCXX_LIBCPPABI_VERSION=2"
    "-DLIBCXX_CXX_ABI=libcxxabi"
  ];

  enableParallelBuilding = true;

  linkCxxAbi = stdenv.isLinux;

  setupHooks = [
    ../../../../../build-support/setup-hooks/role.bash
    ./setup-hook.sh
  ];

  meta = {
    homepage = http://libcxx.llvm.org/;
    description = "A new implementation of the C++ standard library, targeting C++11";
    license = with stdenv.lib.licenses; [ ncsa mit ];
    platforms = stdenv.lib.platforms.unix;
  };
}

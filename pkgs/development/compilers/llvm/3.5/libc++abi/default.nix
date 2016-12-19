{ stdenv, cmake, fetchurl, libcxx, libunwind, llvm }:

let
  version = "3.5.2";
  cmakeLists = fetchurl {
    name   = "CMakeLists.txt";
    url    = "http://llvm.org/svn/llvm-project/libcxxabi/trunk/CMakeLists.txt?p=217324";
    sha256 = "10idgcbs4pcx6mjsbq1vjm8hzqqdk2p7k86cw9f473jmfyfwgf5j";
  };
in stdenv.mkDerivation {
  name = "libc++abi-${version}";

  src = fetchurl {
    url    = "http://llvm.org/releases/${version}/libcxxabi-${version}.src.tar.xz";
    sha256 = "1c6rv0zx0na1w4hdmdfq2f6nj7limb7d1krrknwajxxkcn4yws92";
  };

  buildInputs = [ cmake ] ++ stdenv.lib.optional (!stdenv.isDarwin) libunwind;

  postUnpack = ''
    unpackFile ${libcxx.src}
    unpackFile ${llvm.src}
    echo cp ${cmakeLists} libcxxabi-*/CMakeLists.txt
    cp ${cmakeLists} libcxxabi-*/CMakeLists.txt
    export NIX_CFLAGS_COMPILE+=" -I$PWD/include"
    export cmakeFlags="-DLLVM_PATH=$PWD/$(ls -d llvm-*) -DLIBCXXABI_LIBCXX_INCLUDES=$PWD/$(ls -d libcxx-*)/include"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export TRIPLE=x86_64-apple-darwin
  '';

  installPhase = if stdenv.isDarwin
    then ''
      for file in lib/*; do
        # this should be done in CMake, but having trouble figuring out
        # the magic combination of necessary CMake variables
        # if you fancy a try, take a look at
        # http://www.cmake.org/Wiki/CMake_RPATH_handling
        install_name_tool -id $out/$file $file
      done
      make install
      install -d 755 $out/include
      install -m 644 ../include/cxxabi.h $out/include
    ''
    else ''
      install -d -m 755 $out/include $out/lib
      install -m 644 lib/libc++abi.so.1.0 $out/lib
      install -m 644 $src/include/cxxabi.h $out/include
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so.1
    '';

  meta = {
    homepage = http://libcxxabi.llvm.org/;
    description = "A new implementation of low level support for a standard C++ library";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ vlstill ];
    platforms = stdenv.lib.platforms.unix;
  };
}

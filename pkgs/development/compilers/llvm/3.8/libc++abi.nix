{ stdenv, cmake, fetch, libcxx, libunwind, llvm, version }:

stdenv.mkDerivation {
  name = "libc++abi-${version}";

  src = fetch "libcxxabi" "0175rv2ynkklbg96kpw13iwhnzyrlw3r12f4h09p9v7nmxqhivn5";

  buildInputs = [ cmake ] ++ stdenv.lib.optional (!stdenv.isDarwin && !stdenv.isFreeBSD) libunwind;

  postUnpack = ''
    unpackFile ${libcxx.src}
    unpackFile ${llvm.src}
    export NIX_CFLAGS_COMPILE+=" -I$PWD/include"
    export cmakeFlags="-DLLVM_PATH=$PWD/$(ls -d llvm-*) -DLIBCXXABI_LIBCXX_INCLUDES=$PWD/$(ls -d libcxx-*)/include"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export TRIPLE=x86_64-apple-darwin
  '';

  installPhase = if stdenv.isDarwin
    then ''
      for file in lib/*.dylib; do
        # this should be done in CMake, but having trouble figuring out
        # the magic combination of necessary CMake variables
        # if you fancy a try, take a look at
        # http://www.cmake.org/Wiki/CMake_RPATH_handling
        install_name_tool -id $out/$file $file
      done
      make install
      install -d 755 $out/include
      install -m 644 ../include/*.h $out/include
    ''
    else ''
      install -d -m 755 $out/include $out/lib
      install -m 644 lib/libc++abi.so.1.0 $out/lib
      install -m 644 ../include/cxxabi.h $out/include
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

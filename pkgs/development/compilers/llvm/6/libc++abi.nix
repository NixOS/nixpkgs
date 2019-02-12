{ stdenv, cmake, fetch, libcxx, libunwind, llvm, version }:

stdenv.mkDerivation {
  name = "libc++abi-${version}";

  src = fetch "libcxxabi" "0prqvdj317qrc8nddaq1hh2ag9algkd9wbkj3y4mr5588k12x7r0";

  nativeBuildInputs = [ cmake ];
  buildInputs = stdenv.lib.optional (!stdenv.isDarwin && !stdenv.isFreeBSD) libunwind;

  postUnpack = ''
    unpackFile ${libcxx.src}
    unpackFile ${llvm.src}
    export cmakeFlags="-DLLVM_PATH=$PWD/$(ls -d llvm-*) -DLIBCXXABI_LIBCXX_PATH=$PWD/$(ls -d libcxx-*)"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export TRIPLE=x86_64-apple-darwin
  '' + stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    patch -p1 -d $(ls -d libcxx-*) -i ${../libcxx-0001-musl-hacks.patch}
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
      install -m 644 lib/libc++abi.a $out/lib
      install -m 644 lib/libc++abi.so.1.0 $out/lib
      install -m 644 ../include/cxxabi.h $out/include
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so.1
    '';

  meta = {
    homepage = http://libcxxabi.llvm.org/;
    description = "A new implementation of low level support for a standard C++ library";
    license = with stdenv.lib.licenses; [ ncsa mit ];
    maintainers = with stdenv.lib.maintainers; [ vlstill ];
    platforms = stdenv.lib.platforms.unix;
  };
}

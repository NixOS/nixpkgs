{ stdenv, cmake, fetch, fetchpatch, libcxx, libunwind, llvm, version }:

let
  # Newer LLVMs (3.8 onwards) have changed how some basic C++ stuff works, which breaks builds of this older version
  llvm38-and-above = fetchpatch {
    url    = "https://trac.macports.org/raw-attachment/ticket/50304/0005-string-Fix-exception-declaration.patch";
    sha256 = "1lm38n7s0l5dbl7kp4i49pvzxz1mcvlr2vgsnj47agnwhhm63jvr";
  };
in stdenv.mkDerivation {
  name = "libc++abi-${version}";

  src = fetch "libcxxabi" "0ambfcmr2nh88hx000xb7yjm9lsqjjz49w5mlf6dlxzmj3nslzx4";

  buildInputs = [ cmake ] ++ stdenv.lib.optional (!stdenv.isDarwin && !stdenv.isFreeBSD) libunwind;

  postUnpack = ''
    unpackFile ${libcxx.src}
    unpackFile ${llvm.src}
    export NIX_CFLAGS_COMPILE+=" -I$PWD/include"
    export cmakeFlags="-DLLVM_PATH=$PWD/$(ls -d llvm-*) -DLIBCXXABI_LIBCXX_INCLUDES=$PWD/$(ls -d libcxx-*)/include"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export TRIPLE=x86_64-apple-darwin
  '';

  # I can't use patches directly because this is actually a patch for libc++'s source, which we manually extract
  # into the libc++abi build environment above.
  prePatch = ''(
    cd ../libcxx-*
    patch -p1 < ${llvm38-and-above}
  )'';

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
    license = with stdenv.lib.licenses; [ ncsa mit ];
    maintainers = with stdenv.lib.maintainers; [ vlstill ];
    platforms = stdenv.lib.platforms.unix;
  };
}

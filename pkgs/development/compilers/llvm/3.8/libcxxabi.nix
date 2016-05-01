{ stdenv, cmake, fetch, libcxx, libunwind, llvm, fixDarwinDylibNames, version }:

stdenv.mkDerivation
{
  name = "libc++abi-${version}";

  src = fetch "libcxxabi" "c5ee0871aff6ec741380c4899007a7d97f0b791c81df69d25b744eebc5cee504";

  buildInputs = [ cmake ] ++
  stdenv.lib.optional (!stdenv.isDarwin && !stdenv.isFreeBSD) libunwind ++
  stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  postUnpack = ''
    unpackFile ${libcxx.src}
    unpackFile ${llvm.src}
    export cmakeFlags="-DLLVM_PATH=$PWD/$(ls -d llvm-*) -DLIBCXXABI_LIBCXX_INCLUDES=$PWD/$(ls -d libcxx-*)/include"
    export NIX_CFLAGS_COMPILE+=" -I$PWD/include"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export TRIPLE=x86_64-apple-darwin
  '';

  installPhase = if stdenv.isDarwin then
  ''
    make install
    install -d 755 $out/include
    install -m 644 ../include/cxxabi.h $out/include
  ''
  else ''
    install -d -m 755 $out/include $out/lib
    install -m 644 lib/libc++abi.so.1.0 $out/lib
    install -m 644 ../include/cxxabi.h $out/include
    ln -s libc++abi.so.1.0 $out/lib/libc++abi.so
    ln -s libc++abi.so.1.0 $out/lib/libc++abi.so.1
  '';

  meta =
  {
    homepage = http://libcxxabi.llvm.org/;
    description = "A new implementation of low level support for a standard C++ library";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ vlstill ];
    platforms = stdenv.lib.platforms.unix;
  };

}

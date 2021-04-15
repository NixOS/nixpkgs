{ lib, stdenv, cmake, python3, fetch, libcxx, libunwind, llvm, version
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation {
  pname = "libc++abi";
  inherit version;

  src = fetch "libcxxabi" "1cbmzspwjlr8f6sp73pw6ivf4dpg6rpc61by0q1m2zca2k6yif3a";

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = lib.optional (!stdenv.isDarwin && !stdenv.isFreeBSD && !stdenv.hostPlatform.isWasm) libunwind;

  cmakeFlags = lib.optionals (stdenv.hostPlatform.useLLVM or false) [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DLIBCXXABI_USE_LLVM_UNWINDER=ON"
  ] ++ lib.optionals stdenv.hostPlatform.isWasm [
    "-DLIBCXXABI_ENABLE_THREADS=OFF"
    "-DLIBCXXABI_ENABLE_EXCEPTIONS=OFF"
  ] ++ lib.optionals (!enableShared) [
    "-DLIBCXXABI_ENABLE_SHARED=OFF"
  ];

  postUnpack = ''
    unpackFile ${libcxx.src}
    mv libcxx-* libcxx
    unpackFile ${llvm.src}
    mv llvm-* llvm
  '' + lib.optionalString stdenv.isDarwin ''
    export TRIPLE=x86_64-apple-darwin
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    patch -p1 -d libcxx -i ${../../libcxx-0001-musl-hacks.patch}
  '' + lib.optionalString stdenv.hostPlatform.isWasm ''
    patch -p1 -d llvm -i ${./libcxxabi-wasm.patch}
  '';

  installPhase = if stdenv.isDarwin
    then ''
      for file in lib/*.dylib; do
        # this should be done in CMake, but having trouble figuring out
        # the magic combination of necessary CMake variables
        # if you fancy a try, take a look at
        # https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling
        install_name_tool -id $out/$file $file
      done
      make install
      install -d 755 $out/include
      install -m 644 ../include/*.h $out/include
    ''
    else ''
      install -d -m 755 $out/include $out/lib
      install -m 644 lib/libc++abi.a $out/lib
      install -m 644 ../include/cxxabi.h $out/include
    '' + lib.optionalString enableShared ''
      install -m 644 lib/libc++abi.so.1.0 $out/lib
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so.1
    '';

  meta = {
    homepage = "https://libcxxabi.llvm.org/";
    description = "A new implementation of low level support for a standard C++ library";
    license = with lib.licenses; [ ncsa mit ];
    maintainers = with lib.maintainers; [ vlstill ];
    platforms = lib.platforms.all;
  };
}

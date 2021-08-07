{ lib, stdenv, llvm_meta, cmake, fetch, libcxx, libunwind, llvm, version
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation {
  pname = "libcxxabi";
  inherit version;

  src = fetch "libcxxabi" "1azcf31mxw59hb1x17xncnm3dyw90ylh8rqx462lvypqh3nr6c8l";

  outputs = [ "out" "dev" ];

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
    patch -p1 -d llvm -i ${./wasm.patch}
  '';

  patches = [
    ./no-threads.patch
    ./gnu-install-dirs.patch
  ];

  nativeBuildInputs = [ cmake ];
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

  installPhase = if stdenv.isDarwin
    then ''
      for file in lib/*.dylib; do
        # this should be done in CMake, but having trouble figuring out
        # the magic combination of necessary CMake variables
        # if you fancy a try, take a look at
        # https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling
        ${stdenv.cc.targetPrefix}install_name_tool -id $out/$file $file
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

  meta = llvm_meta // {
    homepage = "https://libcxxabi.llvm.org/";
    description = "Provides C++ standard library support";
    longDescription = ''
      libc++abi is a new implementation of low level support for a standard C++ library.
    '';
    # "All of the code in libc++abi is dual licensed under the MIT license and
    # the UIUC License (a BSD-like license)":
    license = with lib.licenses; [ mit ncsa ];
    maintainers = llvm_meta.maintainers ++ [ lib.maintainers.vlstill ];
  };
}

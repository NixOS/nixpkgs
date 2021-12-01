{ lib, stdenv, llvm_meta, cmake, fetch, libcxx, libunwind, llvm, version
, fetchpatch
, standalone ? stdenv.hostPlatform.useLLVM or false
, withLibunwind ? !stdenv.isDarwin && !stdenv.isFreeBSD && !stdenv.hostPlatform.isWasm
  # on musl the shared objects don't build
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation {
  pname = "libcxxabi";
  inherit version;

  src = fetch "libcxxabi" "1zcqxsdjhawgz1cvpk07y3jl6fg9p3ay4nl69zsirqb2ghgyhhb2";

  outputs = [ "out" "dev" ];

  postUnpack = ''
    unpackFile ${libcxx.src}
    unpackFile ${llvm.src}
    cmakeFlagsArray=($cmakeFlagsArray -DLLVM_PATH=$PWD/$(ls -d llvm-*) -DLIBCXXABI_LIBCXX_PATH=$PWD/$(ls -d libcxx-*) )
  '' + lib.optionalString stdenv.isDarwin ''
    export TRIPLE=x86_64-apple-darwin
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    patch -p1 -d $(ls -d libcxx-*) -i ${../../libcxx-0001-musl-hacks.patch}
  '' + lib.optionalString (!stdenv.cc.isClang) ''
    pushd libcxx-*
    patch -p2 < ${fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/76ccec07b4fa0cc68dfd07d557e7fb661804a468.patch";
      sha256 = "1lgzkfkp7qinfc6gd8x5di1iq1gqdv81249c6f02chn9q122sbq1";
    }}
    popd
  '';

  patches = [
    ./gnu-install-dirs.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional withLibunwind libunwind;

  cmakeFlags = lib.optionals standalone [
    "-DLLVM_ENABLE_LIBCXX=ON"
  ] ++ lib.optionals (standalone && withLibunwind) [
    "-DLIBCXXABI_USE_LLVM_UNWINDER=ON"
  ] ++ lib.optional (!enableShared) "-DLIBCXXABI_ENABLE_SHARED=OFF";

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
      ${lib.optionalString enableShared "install -m 644 lib/libc++abi.so.1.0 $out/lib"}
      install -m 644 ../include/cxxabi.h $out/include
      ${lib.optionalString enableShared "ln -s libc++abi.so.1.0 $out/lib/libc++abi.so"}
      ${lib.optionalString enableShared "ln -s libc++abi.so.1.0 $out/lib/libc++abi.so.1"}
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

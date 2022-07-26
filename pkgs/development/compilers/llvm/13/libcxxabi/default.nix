{ lib, stdenv, llvm_meta, cmake, python3, src, cxx-headers, libunwind, version
, enableShared ? !stdenv.hostPlatform.isStatic
, standalone ? stdenv.hostPlatform.useLLVM or false
, withLibunwind ? !stdenv.isDarwin && !stdenv.isFreeBSD && !stdenv.hostPlatform.isWasm
}:

stdenv.mkDerivation rec {
  pname = "libcxxabi";
  inherit version;

  inherit src;
  sourceRoot = "source/${pname}";

  outputs = [ "out" "dev" ];

  postUnpack = lib.optionalString stdenv.isDarwin ''
    export TRIPLE=x86_64-apple-darwin
  '' + lib.optionalString stdenv.hostPlatform.isWasm ''
    patch -p1 -d llvm -i ${./wasm.patch}
  '';

  patches = [
    ./gnu-install-dirs.patch
  ];

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = lib.optional withLibunwind libunwind;

  cmakeFlags = [
    "-DLIBCXXABI_LIBCXX_INCLUDES=${cxx-headers}/include/c++/v1"
  ] ++ lib.optionals standalone [
    "-DLLVM_ENABLE_LIBCXX=ON"
  ] ++ lib.optionals (standalone && withLibunwind) [
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

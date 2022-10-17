{ lib, stdenv, llvm_meta, fetch, cmake, python3, libcxxabi, llvm, fixDarwinDylibNames, version
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation {
  pname = "libcxx";
  inherit version;

  src = fetch "libcxx" "05cx39ldlxchck454lgfly1xj0c7x65iyx4hqhiihrlg6p6qj854";

  postUnpack = ''
    unpackFile ${libcxxabi.src}
    mv libcxxabi-* libcxxabi
    unpackFile ${llvm.src}
    mv llvm-* llvm
  '';

  outputs = [ "out" "dev" ];

  patches = [
    ./gnu-install-dirs.patch
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    ../../libcxx-0001-musl-hacks.patch
  ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    patchShebangs utils/cat_files.py
  '';

  nativeBuildInputs = [ cmake python3 ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [ libcxxabi ];

  cmakeFlags = [
    "-DLIBCXX_CXX_ABI=libcxxabi"
  ] ++ lib.optional (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isWasi) "-DLIBCXX_HAS_MUSL_LIBC=1"
    ++ lib.optional (stdenv.hostPlatform.useLLVM or false) "-DLIBCXX_USE_COMPILER_RT=ON"
    ++ lib.optional stdenv.hostPlatform.isWasm [
      "-DLIBCXX_ENABLE_THREADS=OFF"
      "-DLIBCXX_ENABLE_FILESYSTEM=OFF"
      "-DLIBCXX_ENABLE_EXCEPTIONS=OFF"
    ] ++ lib.optional (!enableShared) "-DLIBCXX_ENABLE_SHARED=OFF";

  passthru = {
    isLLVM = true;
  };

  meta = llvm_meta // {
    homepage = "https://libcxx.llvm.org/";
    description = "C++ standard library";
    longDescription = ''
      libc++ is an implementation of the C++ standard library, targeting C++11,
      C++14 and above.
    '';
    # "All of the code in libc++ is dual licensed under the MIT license and the
    # UIUC License (a BSD-like license)":
    license = with lib.licenses; [ mit ncsa ];
  };
}

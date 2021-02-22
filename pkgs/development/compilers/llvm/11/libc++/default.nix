{ lib, stdenv, fetch, cmake, python3, libcxxabi, llvm, fixDarwinDylibNames, version
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation {
  pname = "libc++";
  inherit version;

  src = fetch "libcxx" "0gaybwkn76vhakvipxslp7pmv2wm7agxkqwk5f5aizhzc9lzdmcz";

  postUnpack = ''
    unpackFile ${libcxxabi.src}
    mv libcxxabi-* libcxxabi
    unpackFile ${llvm.src}
    mv llvm-* llvm
  '';

  patches = lib.optional stdenv.hostPlatform.isMusl ../../libcxx-0001-musl-hacks.patch;

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

  meta = {
    homepage = "https://libcxx.llvm.org/";
    description = "A new implementation of the C++ standard library, targeting C++11";
    license = with lib.licenses; [ ncsa mit ];
    platforms = lib.platforms.all;
  };
}

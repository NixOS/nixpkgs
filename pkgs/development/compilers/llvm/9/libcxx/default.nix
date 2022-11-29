{ lib, stdenv, llvm_meta, fetch, cmake, python3, libcxxabi, fixDarwinDylibNames, version
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation {
  pname = "libcxx";
  inherit version;

  src = fetch "libcxx" "0d2bj5i6mk4caq7skd5nsdmz8c2m5w5anximl5wz3x32p08zz089";

  postUnpack = ''
    unpackFile ${libcxxabi.src}
    export LIBCXXABI_INCLUDE_DIR="$PWD/$(ls -d libcxxabi-${version}*)/include"
  '';

  outputs = [ "out" "dev" ];

  patches = [
    ./gnu-install-dirs.patch
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    ../../libcxx-0001-musl-hacks.patch
  ];

  # Prevent errors like "error: 'foo' is unavailable: introduced in macOS yy.zz"
  postPatch = ''
    substituteInPlace include/__config \
      --replace "#    define _LIBCPP_USE_AVAILABILITY_APPLE" ""
  '';

  preConfigure = ''
    # Get headers from the cxxabi source so we can see private headers not installed by the cxxabi package
    cmakeFlagsArray=($cmakeFlagsArray -DLIBCXX_CXX_ABI_INCLUDE_PATHS="$LIBCXXABI_INCLUDE_DIR")
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    patchShebangs utils/cat_files.py
  '';
  nativeBuildInputs = [ cmake ]
    ++ lib.optional (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isWasi) python3
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [ libcxxabi ];

  cmakeFlags = [
    "-DLIBCXX_LIBCXXABI_LIB_PATH=${libcxxabi}/lib"
    "-DLIBCXX_LIBCPPABI_VERSION=2"
    "-DLIBCXX_CXX_ABI=libcxxabi"
  ] ++ lib.optional (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isWasi) "-DLIBCXX_HAS_MUSL_LIBC=1"
    ++ lib.optional (stdenv.hostPlatform.useLLVM or false) "-DLIBCXX_USE_COMPILER_RT=ON"
    ++ lib.optionals stdenv.hostPlatform.isWasm [
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

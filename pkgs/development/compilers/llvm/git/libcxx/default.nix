{ lib, stdenv, llvm_meta, src, cmake, python3, fixDarwinDylibNames, version
, libcxxabi
, enableShared ? !stdenv.hostPlatform.isStatic

# If headersOnly is true, the resulting package would only include the headers.
# Use this to break the circular dependency between libcxx and libcxxabi.
#
# Some context:
# https://reviews.llvm.org/rG1687f2bbe2e2aaa092f942d4a97d41fad43eedfb
, headersOnly ? false
}:

stdenv.mkDerivation rec {
  pname = if headersOnly then "cxx-headers" else "libcxx";
  inherit version;

  inherit src;
  sourceRoot = "source/libcxx";

  outputs = [ "out" ] ++ lib.optional (!headersOnly) "dev";

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

  buildInputs = lib.optionals (!headersOnly) [ libcxxabi ];

  cmakeFlags = [ "-DLIBCXX_CXX_ABI=libcxxabi" ]
    ++ lib.optional (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isWasi) "-DLIBCXX_HAS_MUSL_LIBC=1"
    ++ lib.optional (stdenv.hostPlatform.useLLVM or false) "-DLIBCXX_USE_COMPILER_RT=ON"
    ++ lib.optionals stdenv.hostPlatform.isWasm [
      "-DLIBCXX_ENABLE_THREADS=OFF"
      "-DLIBCXX_ENABLE_FILESYSTEM=OFF"
      "-DLIBCXX_ENABLE_EXCEPTIONS=OFF"
    ] ++ lib.optional (!enableShared) "-DLIBCXX_ENABLE_SHARED=OFF";

  buildFlags = lib.optional headersOnly "generate-cxx-headers";
  installTargets = lib.optional headersOnly "install-cxx-headers";

  # At this point, cxxabi headers would be installed in the dev output, which
  # prevents moveToOutput from doing its job later in the build process.
  postInstall = lib.optionalString (!headersOnly) ''
    mv "$dev/include/c++/v1/"* "$out/include/c++/v1/"
    pushd "$dev"
    rmdir -p include/c++/v1
    popd
  '';

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

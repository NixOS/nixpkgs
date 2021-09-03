{ lib, stdenv, llvm_meta, fetch, fetchpatch, cmake, python3, libcxxabi, llvm, fixDarwinDylibNames, version
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation {
  pname = "libcxx";
  inherit version;

  src = fetch "libcxx" "1rgqsqpgi0vkga5d7hy0iyfsqgzfz7q1xy7afdfa1snp1qjks8xv";

  postUnpack = ''
    unpackFile ${libcxxabi.src}
    mv libcxxabi-* libcxxabi
    unpackFile ${llvm.src}
    mv llvm-* llvm
  '';

  outputs = [ "out" "dev" ];

  patches = [
    (fetchpatch {
      # Backported from LLVM 12, avoids clashes with commonly used "block.h" header.
      url = "https://github.com/llvm/llvm-project/commit/19bc9ea480b60b607a3e303f20c7a3a2ea553369.patch";
      sha256 = "sha256-aWa66ogmPkG0xHzSfcpD0qZyZQcNKwLV44js4eiun78=";
      stripLen = 1;
    })
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
    ] ++ lib.optional (!enableShared) "-DLIBCXX_ENABLE_SHARED=OFF"

    # TODO: this is a bit of a hack to cross compile to Apple Silicon.  libcxx
    # starting with 11 enables CMAKE_BUILD_WITH_INSTALL_NAME_DIR which requires
    # platform setup for rpaths. In cmake, this is enabled when macos is newer
    # than 10.5. However CMAKE_SYSTEM_VERSION is set to empty (TODO: why?)
    # which prevents the conditional configuration, and configure fails.  The
    # value here corresponds to `uname -r`. If stdenv.hostPlatform.release is
    # not null, then this property will be set via mkDerivation (TODO: how can
    # we set this?).
    ++ lib.optional (
      stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 &&
      stdenv.hostPlatform != stdenv.buildPlatform
    ) "-DCMAKE_SYSTEM_VERSION=20.1.0";

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

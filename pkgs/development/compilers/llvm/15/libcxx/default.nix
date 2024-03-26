{ lib, stdenv, llvm_meta
, monorepoSrc, runCommand, fetchpatch, substitute
, cmake, lndir, ninja, python3, fixDarwinDylibNames, version
, cxxabi ? if stdenv.hostPlatform.isFreeBSD then libcxxrt else null
, libcxxrt, libunwind
, enableShared ? !stdenv.hostPlatform.isStatic
}:

# external cxxabi is not supported on Darwin as the build will not link libcxx
# properly and not re-export the cxxabi symbols into libcxx
# https://github.com/NixOS/nixpkgs/issues/166205
# https://github.com/NixOS/nixpkgs/issues/269548
assert cxxabi == null || !stdenv.hostPlatform.isDarwin;
let
  basename = "libcxx";
  cxxabiName = "lib${if cxxabi == null then "cxxabi" else cxxabi.libName}";
  runtimes = [ "libcxx" ] ++ lib.optional (cxxabi == null) "libcxxabi";

  # Note: useLLVM is likely false for Darwin but true under pkgsLLVM
  useLLVM = stdenv.hostPlatform.useLLVM or false;

  cxxabiCMakeFlags = lib.optionals (useLLVM && !stdenv.hostPlatform.isWasm) [
    "-DLIBCXXABI_USE_COMPILER_RT=ON"
    "-DLIBCXXABI_USE_LLVM_UNWINDER=ON"
  ] ++ lib.optionals stdenv.hostPlatform.isWasm [
    "-DLIBCXXABI_ENABLE_THREADS=OFF"
    "-DLIBCXXABI_ENABLE_EXCEPTIONS=OFF"
  ] ++ lib.optionals (!enableShared) [
    "-DLIBCXXABI_ENABLE_SHARED=OFF"
  ];

  cxxCMakeFlags = [
    "-DLIBCXX_CXX_ABI=${cxxabiName}"
  ] ++ lib.optionals (cxxabi != null) [
    "-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${lib.getDev cxxabi}/include"
  ] ++ lib.optionals (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isWasi) [
    "-DLIBCXX_HAS_MUSL_LIBC=1"
  ] ++ lib.optionals useLLVM [
    "-DLIBCXX_USE_COMPILER_RT=ON"
  ] ++ lib.optionals stdenv.hostPlatform.isWasm [
    "-DLIBCXX_ENABLE_THREADS=OFF"
    "-DLIBCXX_ENABLE_FILESYSTEM=OFF"
    "-DLIBCXX_ENABLE_EXCEPTIONS=OFF"
  ] ++ lib.optionals (!enableShared) [
    "-DLIBCXX_ENABLE_SHARED=OFF"
  ];

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${lib.concatStringsSep ";" runtimes}"
  ] ++ lib.optionals (useLLVM && !stdenv.hostPlatform.isWasm) [
    # libcxxabi's CMake looks as though it treats -nostdlib++ as implying -nostdlib,
    # but that does not appear to be the case for example when building
    # pkgsLLVM.libcxxabi (which uses clangNoCompilerRtWithLibc).
    "-DCMAKE_EXE_LINKER_FLAGS=-nostdlib"
    "-DCMAKE_SHARED_LINKER_FLAGS=-nostdlib"
  ] ++ lib.optionals stdenv.hostPlatform.isWasm [
    "-DCMAKE_C_COMPILER_WORKS=ON"
    "-DCMAKE_CXX_COMPILER_WORKS=ON"
    "-DUNIX=ON" # Required otherwise libc++ fails to detect the correct linker
  ] ++ cxxCMakeFlags
    ++ lib.optionals (cxxabi == null) cxxabiCMakeFlags;

in

stdenv.mkDerivation rec {
  pname = basename;
  inherit version cmakeFlags;

  src = runCommand "${pname}-src-${version}" {} (''
    mkdir -p "$out/llvm"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/libcxx "$out"
    cp -r ${monorepoSrc}/llvm/cmake "$out/llvm"
    cp -r ${monorepoSrc}/llvm/utils "$out/llvm"
    cp -r ${monorepoSrc}/third-party "$out"
    cp -r ${monorepoSrc}/runtimes "$out"
  '' + lib.optionalString (cxxabi == null) ''
    cp -r ${monorepoSrc}/libcxxabi "$out"
  '');

  outputs = [ "out" "dev" ];

  patches = [
    # See:
    #   - https://reviews.llvm.org/D133566
    #   - https://github.com/NixOS/nixpkgs/issues/214524#issuecomment-1429146432
    # !!! Drop in LLVM 16+
    (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/57c7bb3ec89565c68f858d316504668f9d214d59.patch";
      hash = "sha256-B07vHmSjy5BhhkGSj3e1E0XmMv5/9+mvC/k70Z29VwY=";
    })
    (substitute {
      src = ../../common/libcxxabi/wasm.patch;
      replacements = [
        "--replace-fail" "/cmake/" "/llvm/cmake/"
      ];
    })
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    (substitute {
      src = ../../common/libcxx/libcxx-0001-musl-hacks.patch;
      replacements = [
        "--replace-fail" "/include/" "/libcxx/include/"
      ];
    })
  ];

  postPatch = ''
    cd runtimes
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    patchShebangs utils/cat_files.py
  '';

  nativeBuildInputs = [ cmake ninja python3 ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames
    ++ lib.optional (cxxabi != null) lndir;

  buildInputs = [ cxxabi ]
    ++ lib.optionals (useLLVM && !stdenv.hostPlatform.isWasm) [ libunwind ];

  # libc++.so is a linker script which expands to multiple libraries,
  # libc++.so.1 and libc++abi.so or the external cxxabi. ld-wrapper doesn't
  # support linker scripts so the external cxxabi needs to be symlinked in
  postInstall = lib.optionalString (cxxabi != null) ''
    lndir ${lib.getDev cxxabi}/include ''${!outputDev}/include/c++/v1
    lndir ${lib.getLib cxxabi}/lib ''${!outputLib}/lib
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

{ lib, stdenv, llvm_meta
, monorepoSrc, runCommand
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

  cxxabiCMakeFlags = [
    "-DLIBCXXABI_USE_LLVM_UNWINDER=OFF"
  ] ++ lib.optionals (useLLVM && !stdenv.hostPlatform.isWasm) [
    "-DLIBCXXABI_ADDITIONAL_LIBRARIES=unwind"
    "-DLIBCXXABI_USE_COMPILER_RT=ON"
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
  ] ++ lib.optionals (lib.versionAtLeast version "18" && !useLLVM && stdenv.hostPlatform.libc == "glibc" && !stdenv.hostPlatform.isStatic) [
    "-DLIBCXX_ADDITIONAL_LIBRARIES=gcc_s"
  ] ++ lib.optionals useLLVM [
    "-DLIBCXX_USE_COMPILER_RT=ON"
    # There's precedent for this in llvm-project/libcxx/cmake/caches.
    # In a monorepo build you might do the following in the libcxxabi build:
    #   -DLLVM_ENABLE_PROJECTS=libcxxabi;libunwinder
    #   -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_STATIC_LIBRARY=On
    # libcxx appears to require unwind and doesn't pull it in via other means.
    "-DLIBCXX_ADDITIONAL_LIBRARIES=unwind"
  ] ++ lib.optionals stdenv.hostPlatform.isWasm [
    "-DLIBCXX_ENABLE_THREADS=OFF"
    "-DLIBCXX_ENABLE_FILESYSTEM=OFF"
    "-DLIBCXX_ENABLE_EXCEPTIONS=OFF"
  ] ++ lib.optionals (!enableShared) [
    "-DLIBCXX_ENABLE_SHARED=OFF"
  ];

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${lib.concatStringsSep ";" runtimes}"
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

  patches = lib.optionals (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.13") [
    # https://github.com/llvm/llvm-project/issues/64226
    ./0001-darwin-10.12-mbstate_t-fix.patch
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

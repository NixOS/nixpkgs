{ lib
, stdenv
, llvm_meta
, release_version
, monorepoSrc ? null
, src ? null
, patches ? []
, runCommand
, substitute
, cmake
, ninja
, python3
, fixDarwinDylibNames
, version
, libunwind
, enableShared ? !stdenv.hostPlatform.isStatic
}:

let
  basename = "libcxx";
  pname = basename;

  # Note: useLLVM is likely false for Darwin but true under pkgsLLVM
  useLLVM = stdenv.hostPlatform.useLLVM or false;

  src' = if monorepoSrc != null then
    runCommand "${pname}-src-${version}" {} (''
      mkdir -p "$out/llvm"
      cp -r ${monorepoSrc}/libcxx "$out"
      cp -r ${monorepoSrc}/llvm/cmake "$out/llvm"
      cp -r ${monorepoSrc}/llvm/utils "$out/llvm"
      cp -r ${monorepoSrc}/runtimes "$out"
      cp -r ${monorepoSrc}/libcxxabi "$out"
    '' + lib.optionalString (lib.versionAtLeast release_version "14") ''
      cp -r ${monorepoSrc}/third-party "$out"
      cp -r ${monorepoSrc}/cmake "$out"
    '') else src;

  cxxabiCMakeFlags = lib.optionals (lib.versionAtLeast release_version "18") [
    "-DLIBCXXABI_USE_LLVM_UNWINDER=OFF"
  ] ++ lib.optionals (useLLVM && !stdenv.hostPlatform.isWasm) (if lib.versionAtLeast release_version "18" then [
    "-DLIBCXXABI_ADDITIONAL_LIBRARIES=unwind"
    "-DLIBCXXABI_USE_COMPILER_RT=ON"
  ] else [
    "-DLIBCXXABI_USE_COMPILER_RT=ON"
    "-DLIBCXXABI_USE_LLVM_UNWINDER=ON"
  ]) ++ lib.optionals stdenv.hostPlatform.isWasm [
    "-DLIBCXXABI_ENABLE_THREADS=OFF"
    "-DLIBCXXABI_ENABLE_EXCEPTIONS=OFF"
  ] ++ lib.optionals (!enableShared) [
    "-DLIBCXXABI_ENABLE_SHARED=OFF"
  ];

  cxxCMakeFlags = [
    "-DLIBCXX_CXX_ABI=libcxxabi"
  ] ++ lib.optionals (lib.versionAtLeast release_version "16") [
    # Note: llvm < 16 doesn't support this flag (or it's broken); handled in postInstall instead.
    # Include libc++abi symbols within libc++.a for static linking libc++;
    # dynamic linking includes them through libc++.so being a linker script
    # which includes both shared objects.
    "-DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON"
  ] ++ lib.optionals (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isWasi) [
    "-DLIBCXX_HAS_MUSL_LIBC=1"
  ] ++ lib.optionals (lib.versionAtLeast release_version "18" && !useLLVM && stdenv.hostPlatform.libc == "glibc" && !stdenv.hostPlatform.isStatic) [
    "-DLIBCXX_ADDITIONAL_LIBRARIES=gcc_s"
  ] ++ lib.optionals useLLVM [
    "-DLIBCXX_USE_COMPILER_RT=ON"
  ] ++ lib.optionals (useLLVM && lib.versionAtLeast release_version "16") [
    "-DLIBCXX_ADDITIONAL_LIBRARIES=unwind"
  ] ++ lib.optionals stdenv.hostPlatform.isWasm [
    "-DLIBCXX_ENABLE_THREADS=OFF"
    "-DLIBCXX_ENABLE_FILESYSTEM=OFF"
    "-DLIBCXX_ENABLE_EXCEPTIONS=OFF"
  ] ++ lib.optionals (!enableShared) [
    "-DLIBCXX_ENABLE_SHARED=OFF"
  ];

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=libcxx;libcxxabi"
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
    ++ cxxabiCMakeFlags;

in

stdenv.mkDerivation (rec {
  inherit pname version cmakeFlags patches;

  src = src';

  outputs = [ "out" "dev" ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    patchShebangs utils/cat_files.py
  '';

  nativeBuildInputs = [ cmake ninja python3 ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = lib.optionals (useLLVM && !stdenv.hostPlatform.isWasm) [ libunwind ];

  # LIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON doesn't work for LLVM < 16 so
  # merge libc++abi.a into libc++.a ourselves.
  #
  # GNU binutils emits objects in LIFO order in MRI scripts so after the merge
  # the objects are in reversed order so a second MRI script is required so the
  # objects in the archive are listed in proper order (libc++.a, libc++abi.a)
  postInstall = lib.optionalString (lib.versionOlder release_version "16") ''
    if [[ -f $out/lib/libc++.a && -f $out/lib/libc++abi.a ]]; then
      $AR -M <<MRI
        create $out/lib/libc++.a
        addlib $out/lib/libc++.a
        addlib $out/lib/libc++abi.a
        save
        end
    MRI
      $AR -M <<MRI
        create $out/lib/libc++.a
        addlib $out/lib/libc++.a
        save
        end
    MRI
    fi
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
} // (if (lib.versionOlder release_version "16" || lib.versionAtLeast release_version "17") then {
  postPatch = (lib.optionalString (lib.versionAtLeast release_version "14" && lib.versionOlder release_version "15") ''
    # fix CMake error when static and LIBCXXABI_USE_LLVM_UNWINDER=ON. aren't
    # building unwind so don't need to depend on it
    substituteInPlace libcxx/src/CMakeLists.txt \
      --replace-fail "add_dependencies(cxx_static unwind)" "# add_dependencies(cxx_static unwind)"
  '') + ''
    cd runtimes
  '';
} else {
  sourceRoot = "${src'.name}/runtimes";
}))

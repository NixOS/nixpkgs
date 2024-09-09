{ lib
, stdenv
, llvm_meta
, release_version
, monorepoSrc ? null
, src ? null
, patches ? []
, runCommand
, cmake
, lndir
, ninja
, python3
, fixDarwinDylibNames
, version
, freebsd
, cxxabi ? if stdenv.hostPlatform.isFreeBSD then freebsd.libcxxrt else null
, libunwind
, enableShared ? !stdenv.hostPlatform.isStatic
}:

# external cxxabi is not supported on Darwin as the build will not link libcxx
# properly and not re-export the cxxabi symbols into libcxx
# https://github.com/NixOS/nixpkgs/issues/166205
# https://github.com/NixOS/nixpkgs/issues/269548
assert cxxabi == null || !stdenv.hostPlatform.isDarwin;
let
  basename = "libcxx";
  pname = basename;
  cxxabiName = "lib${if cxxabi == null then "cxxabi" else cxxabi.libName}";
  runtimes = [ "libcxx" ] ++ lib.optional (cxxabi == null) "libcxxabi";

  # Note: useLLVM is likely false for Darwin but true under pkgsLLVM
  useLLVM = stdenv.hostPlatform.useLLVM or false;

  src' = if monorepoSrc != null then
    runCommand "${pname}-src-${version}" {} (''
      mkdir -p "$out/llvm"
    '' + (lib.optionalString (lib.versionAtLeast release_version "14") ''
      cp -r ${monorepoSrc}/cmake "$out"
    '') + ''
      cp -r ${monorepoSrc}/libcxx "$out"
      cp -r ${monorepoSrc}/llvm/cmake "$out/llvm"
      cp -r ${monorepoSrc}/llvm/utils "$out/llvm"
    '' + (lib.optionalString (lib.versionAtLeast release_version "14") ''
      cp -r ${monorepoSrc}/third-party "$out"
    '') + ''
      cp -r ${monorepoSrc}/runtimes "$out"
    '' + (lib.optionalString (cxxabi == null) ''
      cp -r ${monorepoSrc}/libcxxabi "$out"
    '')) else src;

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
    "-DLIBCXX_CXX_ABI=${cxxabiName}"
  ] ++ lib.optionals (cxxabi == null && lib.versionAtLeast release_version "16") [
    # Note: llvm < 16 doesn't support this flag (or it's broken); handled in postInstall instead.
    # Include libc++abi symbols within libc++.a for static linking libc++;
    # dynamic linking includes them through libc++.so being a linker script
    # which includes both shared objects.
    "-DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON"
  ] ++ lib.optionals (cxxabi != null) [
    "-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${lib.getDev cxxabi}/include"
  ] ++ lib.optionals (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isWasi) [
    "-DLIBCXX_HAS_MUSL_LIBC=1"
  ] ++ lib.optionals (lib.versionAtLeast release_version "18" && !useLLVM && stdenv.hostPlatform.libc == "glibc" && !stdenv.hostPlatform.isStatic) [
    "-DLIBCXX_ADDITIONAL_LIBRARIES=gcc_s"
  ] ++ lib.optionals (lib.versionAtLeast release_version "18" && stdenv.hostPlatform.isFreeBSD) [
    # Name and documentation claim this is for libc++abi, but its man effect is adding `-lunwind`
    # to the libc++.so linker script. We want FreeBSD's so-called libgcc instead of libunwind.
    "-DLIBCXXABI_USE_LLVM_UNWINDER=OFF"
  ] ++ lib.optionals useLLVM [
    "-DLIBCXX_USE_COMPILER_RT=ON"
  ] ++ lib.optionals (useLLVM && !stdenv.hostPlatform.isFreeBSD && lib.versionAtLeast release_version "16") [
    "-DLIBCXX_ADDITIONAL_LIBRARIES=unwind"
  ] ++ lib.optionals stdenv.hostPlatform.isWasm [
    "-DLIBCXX_ENABLE_THREADS=OFF"
    "-DLIBCXX_ENABLE_FILESYSTEM=OFF"
    "-DLIBCXX_ENABLE_EXCEPTIONS=OFF"
  ] ++ lib.optionals (!enableShared) [
    "-DLIBCXX_ENABLE_SHARED=OFF"
  ] ++ lib.optionals (cxxabi != null && cxxabi.libName == "cxxrt") [
    "-DLIBCXX_ENABLE_NEW_DELETE_DEFINITIONS=ON"
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

stdenv.mkDerivation (rec {
  inherit pname version cmakeFlags patches;

  src = src';

  outputs = [ "out" "dev" ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    patchShebangs utils/cat_files.py
  '';

  nativeBuildInputs = [ cmake ninja python3 ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames
    ++ lib.optional (cxxabi != null) lndir;

  buildInputs = [ cxxabi ]
    ++ lib.optionals (useLLVM && !stdenv.hostPlatform.isWasm && !stdenv.hostPlatform.isFreeBSD) [ libunwind ];

  # libc++.so is a linker script which expands to multiple libraries,
  # libc++.so.1 and libc++abi.so or the external cxxabi. ld-wrapper doesn't
  # support linker scripts so the external cxxabi needs to be symlinked in
  postInstall = lib.optionalString (cxxabi != null) ''
    lndir ${lib.getDev cxxabi}/include $dev/include/c++/v1
    lndir ${lib.getLib cxxabi}/lib $out/lib
    libcxxabi=$out/lib/lib${cxxabi.libName}.a
  ''
  # LIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON doesn't work for LLVM < 16 or
  # external cxxabi libraries so merge libc++abi.a into libc++.a ourselves.

  # GNU binutils emits objects in LIFO order in MRI scripts so after the merge
  # the objects are in reversed order so a second MRI script is required so the
  # objects in the archive are listed in proper order (libc++.a, libc++abi.a)
  + lib.optionalString (cxxabi != null || lib.versionOlder release_version "16") ''
    libcxxabi=''${libcxxabi-$out/lib/libc++abi.a}
    if [[ -f $out/lib/libc++.a && -e $libcxxabi ]]; then
      $AR -M <<MRI
        create $out/lib/libc++.a
        addlib $out/lib/libc++.a
        addlib $libcxxabi
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

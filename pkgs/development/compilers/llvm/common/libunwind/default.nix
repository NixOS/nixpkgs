{ lib
, stdenv
, release_version
, patches ? []
, src ? null
, llvm_meta
, version
, monorepoSrc ? null
, runCommand
, cmake
, ninja
, python3
, libcxx
, enableShared ? !stdenv.hostPlatform.isStatic
, devExtraCmakeFlags ? []
}:
let
  pname = "libunwind";
  src' = if monorepoSrc != null then
    runCommand "${pname}-src-${version}" {} (''
      mkdir -p "$out"
      cp -r ${monorepoSrc}/cmake "$out"
      cp -r ${monorepoSrc}/${pname} "$out"
      mkdir -p "$out/libcxx"
      cp -r ${monorepoSrc}/libcxx/cmake "$out/libcxx"
      cp -r ${monorepoSrc}/libcxx/utils "$out/libcxx"
      mkdir -p "$out/llvm"
      cp -r ${monorepoSrc}/llvm/cmake "$out/llvm"
    '' + lib.optionalString (lib.versionAtLeast release_version "15") ''
      cp -r ${monorepoSrc}/llvm/utils "$out/llvm"
      cp -r ${monorepoSrc}/runtimes "$out"
    '') else src;

  hasPatches = builtins.length patches > 0;

  postUnpack = lib.optionalString (lib.versions.major release_version == "12") ''
    ln -s ${libcxx.src}/libcxx .
    ln -s ${libcxx.src}/llvm .
  '';

  prePatch = lib.optionalString (lib.versionAtLeast release_version "15" && (hasPatches || lib.versionOlder release_version "18")) ''
    cd ../${pname}
    chmod -R u+w .
  '';

  postPatch = lib.optionalString (lib.versionAtLeast release_version "15" && (hasPatches || lib.versionOlder release_version "18")) ''
    cd ../runtimes
  '';

  postInstall = lib.optionalString (enableShared && !stdenv.hostPlatform.isDarwin) ''
    # libcxxabi wants to link to libunwind_shared.so (?).
    ln -s $out/lib/libunwind.so $out/lib/libunwind_shared.so
  '';
in
stdenv.mkDerivation (rec {
  inherit pname version patches;

  src = src';

  sourceRoot =
    if lib.versionOlder release_version "13" then null
    else if lib.versionAtLeast release_version "15" then "${src.name}/runtimes"
    else "${src.name}/${pname}";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals (lib.versionAtLeast release_version "15") [
    ninja python3
  ];

  cmakeFlags = lib.optional (lib.versionAtLeast release_version "15") "-DLLVM_ENABLE_RUNTIMES=libunwind"
    ++ lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF"
    ++ devExtraCmakeFlags;

  meta = llvm_meta // {
    # Details: https://github.com/llvm/llvm-project/blob/main/libunwind/docs/index.rst
    homepage = "https://clang.llvm.org/docs/Toolchain.html#unwind-library";
    description = "LLVM's unwinder library";
    longDescription = ''
      The unwind library provides a family of _Unwind_* functions implementing
      the language-neutral stack unwinding portion of the Itanium C++ ABI (Level
      I). It is a dependency of the C++ ABI library, and sometimes is a
      dependency of other runtimes.
    '';
  };
} // (if postUnpack != "" then { inherit postUnpack; } else {})
  // (if (lib.versionAtLeast release_version "15") then { inherit postInstall; } else {})
  // (if prePatch != "" then { inherit prePatch; } else {})
  // (if postPatch != "" then { inherit postPatch; } else {}))

{ lib, stdenv, llvm_meta, version
, monorepoSrc, runCommand
, cmake
, python3
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libunwind";
  inherit version;

  # I am not so comfortable giving libc++ and friends the whole monorepo as
  # requested, so I filter it to what is needed.
  src = runCommand "${pname}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
    mkdir -p "$out/libcxx"
    cp -r ${monorepoSrc}/libcxx/cmake "$out/libcxx"
    cp -r ${monorepoSrc}/libcxx/utils "$out/libcxx"
    mkdir -p "$out/llvm"
    cp -r ${monorepoSrc}/llvm/cmake "$out/llvm"
    cp -r ${monorepoSrc}/llvm/utils "$out/llvm"
    cp -r ${monorepoSrc}/runtimes "$out"
  '';

  sourceRoot = "${src.name}/runtimes";

  prePatch = ''
    cd ../${pname}
    chmod -R u+w .
  '';

  patches = [
    ./gnu-install-dirs.patch
  ];

  postPatch = ''
    cd ../runtimes
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake python3 ];

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=libunwind"
  ] ++ lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF";

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
}

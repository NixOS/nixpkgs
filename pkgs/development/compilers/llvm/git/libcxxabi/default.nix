{ lib, stdenv, llvm_meta, cmake, python3
, monorepoSrc, runCommand, fetchpatch
, cxx-headers, libunwind, version
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libcxxabi";
  inherit version;

  src = runCommand "${pname}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
    mkdir -p "$out/libcxx/src"
    cp -r ${monorepoSrc}/libcxx/cmake "$out/libcxx"
    cp -r ${monorepoSrc}/libcxx/include "$out/libcxx"
    cp -r ${monorepoSrc}/libcxx/src/include "$out/libcxx/src"
    mkdir -p "$out/llvm"
    cp -r ${monorepoSrc}/llvm/cmake "$out/llvm"
    cp -r ${monorepoSrc}/llvm/utils "$out/llvm"
    cp -r ${monorepoSrc}/runtimes "$out"
  '';

  sourceRoot = "${src.name}/runtimes";

  outputs = [ "out" "dev" ];

  postUnpack = lib.optionalString stdenv.isDarwin ''
    export TRIPLE=x86_64-apple-darwin
  '' + lib.optionalString stdenv.hostPlatform.isWasm ''
    patch -p1 -d llvm -i ${./wasm.patch}
  '';

  prePatch = ''
    cd ../${pname}
    chmod -R u+w .
  '';

  patches = [
    ./gnu-install-dirs.patch

    # https://reviews.llvm.org/D132298, Allow building libcxxabi alone
    (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/e6a0800532bb409f6d1c62f3698bdd6994a877dc.patch";
      sha256 = "1xyjd56m4pfwq8p3xh6i8lhkk9kq15jaml7qbhxdf87z4jjkk63a";
      stripLen = 1;
    })
  ];

  postPatch = ''
    cd ../runtimes
  '';

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = lib.optional (!stdenv.isDarwin && !stdenv.isFreeBSD && !stdenv.hostPlatform.isWasm) libunwind;

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=libcxxabi"
    "-DLIBCXXABI_LIBCXX_INCLUDES=${cxx-headers}/include/c++/v1"
  ] ++ lib.optionals (stdenv.hostPlatform.useLLVM or false) [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DLIBCXXABI_USE_LLVM_UNWINDER=ON"
  ] ++ lib.optionals stdenv.hostPlatform.isWasm [
    "-DLIBCXXABI_ENABLE_THREADS=OFF"
    "-DLIBCXXABI_ENABLE_EXCEPTIONS=OFF"
  ] ++ lib.optionals (!enableShared) [
    "-DLIBCXXABI_ENABLE_SHARED=OFF"
  ];

  preInstall = lib.optionalString stdenv.isDarwin ''
    for file in lib/*.dylib; do
      # Fix up the install name. Preserve the basename, just replace the path.
      installName="$out/lib/$(basename $(otool -D $file | tail -n 1))"

      # this should be done in CMake, but having trouble figuring out
      # the magic combination of necessary CMake variables
      # if you fancy a try, take a look at
      # https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling
      ${stdenv.cc.targetPrefix}install_name_tool -id $installName $file

      # cc-wrapper passes '-lc++abi' to all c++ link steps, but that causes
      # libcxxabi to sometimes link against a different version of itself.
      # Here we simply make that second reference point to ourselves.
      for other in $(otool -L $file | awk '$1 ~ "/libc\\+\\+abi" { print $1 }'); do
        ${stdenv.cc.targetPrefix}install_name_tool -change $other $installName $file
      done
    done
  '';

  postInstall = ''
    mkdir -p "$dev/include"
    install -m 644 ../../${pname}/include/${if stdenv.isDarwin then "*" else "cxxabi.h"} "$dev/include"
  '';

  meta = llvm_meta // {
    homepage = "https://libcxxabi.llvm.org/";
    description = "Provides C++ standard library support";
    longDescription = ''
      libc++abi is a new implementation of low level support for a standard C++ library.
    '';
    # "All of the code in libc++abi is dual licensed under the MIT license and
    # the UIUC License (a BSD-like license)":
    license = with lib.licenses; [ mit ncsa ];
    maintainers = llvm_meta.maintainers ++ [ lib.maintainers.vlstill ];
  };
}

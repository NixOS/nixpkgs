{ lib, stdenv, llvm_meta
, monorepoSrc, runCommand, fetchpatch
, cmake, ninja, python3, fixDarwinDylibNames, version
, cxxabi ? if stdenv.hostPlatform.isFreeBSD then libcxxrt else libcxxabi
, libcxxabi, libcxxrt, libunwind
, enableShared ? !stdenv.hostPlatform.isStatic

# If headersOnly is true, the resulting package would only include the headers.
# Use this to break the circular dependency between libcxx and libcxxabi.
#
# Some context:
# https://reviews.llvm.org/rG1687f2bbe2e2aaa092f942d4a97d41fad43eedfb
, headersOnly ? false
}:

let
  basename = "libcxx";
in

assert stdenv.isDarwin -> cxxabi.libName == "c++abi";

stdenv.mkDerivation rec {
  pname = basename + lib.optionalString headersOnly "-headers";
  inherit version;

  src = runCommand "${pname}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${basename} "$out"
    mkdir -p "$out/libcxxabi"
    cp -r ${monorepoSrc}/libcxxabi/include "$out/libcxxabi"
    mkdir -p "$out/llvm"
    cp -r ${monorepoSrc}/llvm/cmake "$out/llvm"
    cp -r ${monorepoSrc}/llvm/utils "$out/llvm"
    cp -r ${monorepoSrc}/third-party "$out"
    cp -r ${monorepoSrc}/runtimes "$out"
  '';

  sourceRoot = "${src.name}/runtimes";

  outputs = [ "out" ] ++ lib.optional (!headersOnly) "dev";

  prePatch = ''
    cd ../${basename}
    chmod -R u+w .
  '';

  patches = [
    ./gnu-install-dirs.patch
    # See:
    #   - https://reviews.llvm.org/D133566
    #   - https://github.com/NixOS/nixpkgs/issues/214524#issuecomment-1429146432
    # !!! Drop in LLVM 16+
    (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/57c7bb3ec89565c68f858d316504668f9d214d59.patch";
      hash = "sha256-AaM9A6tQ4YAw7uDqCIV4VaiUyLZv+unwcOqbakwW9/k=";
      relative = "libcxx";
    })
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    ../../libcxx-0001-musl-hacks.patch
  ];

  postPatch = ''
    cd ../runtimes
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    patchShebangs utils/cat_files.py
  '';

  nativeBuildInputs = [ cmake ninja python3 ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs =
    lib.optionals (!headersOnly) [ cxxabi ]
    ++ lib.optionals (stdenv.hostPlatform.useLLVM or false) [ libunwind ];

  cmakeFlags = let
    # See: https://libcxx.llvm.org/BuildingLibcxx.html#cmdoption-arg-libcxx-cxx-abi-string
    libcxx_cxx_abi_opt = {
      "c++abi" = "system-libcxxabi";
      "cxxrt" = "libcxxrt";
    }.${cxxabi.libName} or (throw "unknown cxxabi: ${cxxabi.libName} (${cxxabi.pname})");
  in [
    "-DLLVM_ENABLE_RUNTIMES=libcxx"
    "-DLIBCXX_CXX_ABI=${if headersOnly then "none" else libcxx_cxx_abi_opt}"
  ] ++ lib.optional (!headersOnly && cxxabi.libName == "c++abi") "-DLIBCXX_CXX_ABI_INCLUDE_PATHS=${cxxabi.dev}/include/c++/v1"
    ++ lib.optional (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isWasi) "-DLIBCXX_HAS_MUSL_LIBC=1"
    ++ lib.optionals (stdenv.hostPlatform.useLLVM or false) [
      "-DLIBCXX_USE_COMPILER_RT=ON"
      # (Backport fix from 16, which has LIBCXX_ADDITIONAL_LIBRARIES, but 15
      # does not appear to)
      # There's precedent for this in llvm-project/libcxx/cmake/caches.
      # In a monorepo build you might do the following in the libcxxabi build:
      #   -DLLVM_ENABLE_PROJECTS=libcxxabi;libunwind
      #   -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_STATIC_LIBRARY=On
      # libcxx appears to require unwind and doesn't pull it in via other means.
      # "-DLIBCXX_ADDITIONAL_LIBRARIES=unwind"
      "-DCMAKE_SHARED_LINKER_FLAGS=-lunwind"
    ] ++ lib.optionals stdenv.hostPlatform.isWasm [
      "-DLIBCXX_ENABLE_THREADS=OFF"
      "-DLIBCXX_ENABLE_FILESYSTEM=OFF"
      "-DLIBCXX_ENABLE_EXCEPTIONS=OFF"
    ] ++ lib.optional (!enableShared) "-DLIBCXX_ENABLE_SHARED=OFF"
    # If we're only building the headers we don't actually *need* a functioning
    # C/C++ compiler:
    ++ lib.optionals (headersOnly) [
      "-DCMAKE_C_COMPILER_WORKS=ON"
      "-DCMAKE_CXX_COMPILER_WORKS=ON"
    ];

  ninjaFlags = lib.optional headersOnly "generate-cxx-headers";
  installTargets = lib.optional headersOnly "install-cxx-headers";

  passthru = {
    isLLVM = true;
    inherit cxxabi;
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

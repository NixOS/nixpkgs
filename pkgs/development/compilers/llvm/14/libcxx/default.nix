{ lib, stdenv, llvm_meta
, monorepoSrc, runCommand
, cmake, python3, fixDarwinDylibNames, version
, cxxabi ? if stdenv.hostPlatform.isFreeBSD then libcxxrt else libcxxabi
, libcxxabi, libcxxrt
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

assert stdenv.isDarwin -> cxxabi.pname == "libcxxabi";

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
  '';

  sourceRoot = "${src.name}/${basename}";

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

  buildInputs = lib.optionals (!headersOnly) [ cxxabi ];

  cmakeFlags = [ "-DLIBCXX_CXX_ABI=${cxxabi.pname}" ]
    ++ lib.optional (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isWasi) "-DLIBCXX_HAS_MUSL_LIBC=1"
    ++ lib.optional (stdenv.hostPlatform.useLLVM or false) "-DLIBCXX_USE_COMPILER_RT=ON"
    ++ lib.optionals stdenv.hostPlatform.isWasm [
      "-DLIBCXX_ENABLE_THREADS=OFF"
      "-DLIBCXX_ENABLE_FILESYSTEM=OFF"
      "-DLIBCXX_ENABLE_EXCEPTIONS=OFF"
    ] ++ lib.optional (!enableShared) "-DLIBCXX_ENABLE_SHARED=OFF";

  buildFlags = lib.optional headersOnly "generate-cxx-headers";
  installTargets = lib.optional headersOnly "install-cxx-headers";

  preInstall = lib.optionalString (stdenv.isDarwin && !headersOnly) ''
    for file in lib/*.dylib; do
      if [ -L "$file" ]; then continue; fi

      baseName=$(basename $(${stdenv.cc.targetPrefix}otool -D $file | tail -n 1))
      installName="$out/lib/$baseName"
      abiName=$(echo "$baseName" | sed -e 's/libc++/libc++abi/')

      for other in $(${stdenv.cc.targetPrefix}otool -L $file | awk '$1 ~ "/libc\\+\\+abi" { print $1 }'); do
        ${stdenv.cc.targetPrefix}install_name_tool -change $other ${cxxabi}/lib/$abiName $file
      done
    done
  '';

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

{ lib, stdenv, llvm_meta, fetch, cmake, python3, llvm, fixDarwinDylibNames, version
, cxxabi ? if stdenv.hostPlatform.isFreeBSD then libcxxrt else libcxxabi
, libcxxabi, libcxxrt
, enableShared ? !stdenv.hostPlatform.isStatic
}:

assert stdenv.isDarwin -> cxxabi.pname == "libcxxabi";

stdenv.mkDerivation {
  pname = "libcxx";
  inherit version;

  src = fetch "libcxx" "05cx39ldlxchck454lgfly1xj0c7x65iyx4hqhiihrlg6p6qj854";

  postUnpack = ''
    unpackFile ${libcxxabi.src}
    mv libcxxabi-* libcxxabi
    unpackFile ${llvm.src}
    mv llvm-* llvm
  '';

  outputs = [ "out" "dev" ];

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

  buildInputs = [ cxxabi ];

  cmakeFlags = [
    "-DLIBCXX_CXX_ABI=${cxxabi.pname}"
  ] ++ lib.optional (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.isWasi) "-DLIBCXX_HAS_MUSL_LIBC=1"
    ++ lib.optional (stdenv.hostPlatform.useLLVM or false) "-DLIBCXX_USE_COMPILER_RT=ON"
    ++ lib.optionals stdenv.hostPlatform.isWasm [
      "-DLIBCXX_ENABLE_THREADS=OFF"
      "-DLIBCXX_ENABLE_FILESYSTEM=OFF"
      "-DLIBCXX_ENABLE_EXCEPTIONS=OFF"
    ] ++ lib.optional (!enableShared) "-DLIBCXX_ENABLE_SHARED=OFF";

  preInstall = lib.optionalString (stdenv.isDarwin) ''
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

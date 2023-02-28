{ lib, stdenv, llvm_meta, fetch, cmake, python3, fixDarwinDylibNames, version
, cxxabi ? if stdenv.hostPlatform.isFreeBSD then libcxxrt else libcxxabi
, libcxxabi, libcxxrt
}:

assert stdenv.isDarwin -> cxxabi.pname == "libcxxabi";

stdenv.mkDerivation {
  pname = "libcxx";
  inherit version;

  src = fetch "libcxx" "1672aaf95fgy4xsfra8pw24f6r93zwzpan1033hkcm8p2glqipvf";

  postUnpack = ''
    unpackFile ${libcxxabi.src}
    export LIBCXXABI_INCLUDE_DIR="$PWD/$(ls -d libcxxabi-${version}*)/include"
  '';

  outputs = [ "out" "dev" ];

  patches = [
    ./gnu-install-dirs.patch
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    ../../libcxx-0001-musl-hacks.patch
  ];

  prePatch = ''
    substituteInPlace lib/CMakeLists.txt --replace "/usr/lib/libc++" "\''${LIBCXX_LIBCXXABI_LIB_PATH}/libc++"
  '';

  preConfigure = ''
    # Get headers from the cxxabi source so we can see private headers not installed by the cxxabi package
    cmakeFlagsArray=($cmakeFlagsArray -DLIBCXX_CXX_ABI_INCLUDE_PATHS="$LIBCXXABI_INCLUDE_DIR")
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    patchShebangs utils/cat_files.py
  '';
  nativeBuildInputs = [ cmake ]
    ++ lib.optional stdenv.hostPlatform.isMusl python3
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [ cxxabi ];

  cmakeFlags = [
    "-DLIBCXX_LIBCPPABI_VERSION=2"
    "-DLIBCXX_CXX_ABI=${cxxabi.pname}"
  ] ++ lib.optional stdenv.hostPlatform.isMusl "-DLIBCXX_HAS_MUSL_LIBC=1"
    ++ lib.optional (cxxabi.pname == "libcxxabi") "-DLIBCXX_LIBCXXABI_LIB_PATH=${cxxabi}/lib";

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

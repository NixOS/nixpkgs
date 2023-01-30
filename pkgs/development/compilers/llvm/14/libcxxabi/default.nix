{ lib, stdenv, llvm_meta, cmake, python3
, monorepoSrc, runCommand
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
  '';

  sourceRoot = "${src.name}/${pname}";

  outputs = [ "out" "dev" ];

  postUnpack = lib.optionalString stdenv.isDarwin ''
    export TRIPLE=x86_64-apple-darwin
  '' + lib.optionalString stdenv.hostPlatform.isWasm ''
    patch -p1 -d llvm -i ${./wasm.patch}
  '';

  patches = [
    ./gnu-install-dirs.patch
  ];

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = lib.optional (!stdenv.isDarwin && !stdenv.hostPlatform.isWasm) libunwind;

  cmakeFlags = [
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

  installPhase = if stdenv.isDarwin
    then ''
      for file in lib/*.dylib; do
        if [ -L "$file" ]; then continue; fi

        # Fix up the install name. Preserve the basename, just replace the path.
        installName="$out/lib/$(basename $(${stdenv.cc.targetPrefix}otool -D $file | tail -n 1))"

        # this should be done in CMake, but having trouble figuring out
        # the magic combination of necessary CMake variables
        # if you fancy a try, take a look at
        # https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling
        ${stdenv.cc.targetPrefix}install_name_tool -id $installName $file

        # cc-wrapper passes '-lc++abi' to all c++ link steps, but that causes
        # libcxxabi to sometimes link against a different version of itself.
        # Here we simply make that second reference point to ourselves.
        for other in $(${stdenv.cc.targetPrefix}otool -L $file | awk '$1 ~ "/libc\\+\\+abi" { print $1 }'); do
          ${stdenv.cc.targetPrefix}install_name_tool -change $other $installName $file
        done
      done

      make install
      install -d 755 $out/include
      install -m 644 ../include/*.h $out/include
    ''
    else ''
      install -d -m 755 $out/include $out/lib
      install -m 644 lib/libc++abi.a $out/lib
      install -m 644 ../include/cxxabi.h $out/include
    '' + lib.optionalString enableShared ''
      install -m 644 lib/libc++abi.so.1.0 $out/lib
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so.1
    '';

  passthru = {
    libName = "c++abi";
  };

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

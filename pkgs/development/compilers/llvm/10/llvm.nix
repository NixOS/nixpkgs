{ stdenv
, fetch
, cmake
, python3
, libffi
, libbfd
, libpfm
, libxml2
, ncurses
, version
, release_version
, zlib
, buildPackages
, debugVersion ? false
, enableManpages ? false
, enableSharedLibraries ? true
, enablePFM ? !(stdenv.isDarwin
  || stdenv.isAarch64 # broken for Ampere eMAG 8180 (c2.large.arm on Packet) #56245
)
, enablePolly ? true
}:

let
  inherit (stdenv.lib) optional optionals optionalString;

  # Used when creating a version-suffixed symlink of libLLVM.dylib
  shortVersion = with stdenv.lib;
    concatStringsSep "." (take 1 (splitString "." release_version));

in stdenv.mkDerivation (rec {
  pname = "llvm";
  inherit version;

  src = fetch pname "1pwgm6cr0xr5a0hrbqs1zvsvvjvy0yq1y47c96804wcs795s90yz";
  polly_src = fetch "polly" "15sd3dq0w60jsb76pis09lkagj5iy43h9hg4kd9gx5l8cbnsdyrm";

  unpackPhase = ''
    unpackFile $src
    mv llvm-${version}* llvm
    sourceRoot=$PWD/llvm
  '' + optionalString enablePolly ''
    unpackFile $polly_src
    mv polly-* $sourceRoot/tools/polly
  '';

  outputs = [ "out" "python" ]
    ++ optional enableSharedLibraries "lib";

  nativeBuildInputs = [ cmake python3 ]
    ++ optionals enableManpages [ python3.pkgs.sphinx python3.pkgs.recommonmark ];

  buildInputs = [ libxml2 libffi ]
    ++ optional enablePFM libpfm; # exegesis

  propagatedBuildInputs = [ ncurses zlib ];

  patches = [
    # 10.0.0rc3-only
    ./llvm-extension-handling.patch
  ];

  postPatch = optionalString stdenv.isDarwin ''
    substituteInPlace cmake/modules/AddLLVM.cmake \
      --replace 'set(_install_name_dir INSTALL_NAME_DIR "@rpath")' "set(_install_name_dir)" \
      --replace 'set(_install_rpath "@loader_path/../lib''${LLVM_LIBDIR_SUFFIX}" ''${extra_libdir})' ""
  ''
  # Patch llvm-config to return correct library path based on --link-{shared,static}.
  + optionalString (enableSharedLibraries) ''
    substitute '${./llvm-outputs.patch}' ./llvm-outputs.patch --subst-var lib
    patch -p1 < ./llvm-outputs.patch
  '' + ''
    # FileSystem permissions tests fail with various special bits
    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "Path.cpp" ""
    rm unittests/Support/Path.cpp
  '' + optionalString stdenv.hostPlatform.isMusl ''
    patch -p1 -i ${../TLI-musl.patch}
    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "add_subdirectory(DynamicLibrary)" ""
    rm unittests/Support/DynamicLibrary/DynamicLibraryTest.cpp
    # valgrind unhappy with musl or glibc, but fails w/musl only
    rm test/CodeGen/AArch64/wineh4.mir
  '' + optionalString stdenv.hostPlatform.isAarch32 ''
    # skip failing X86 test cases on 32-bit ARM
    rm test/DebugInfo/X86/convert-debugloc.ll
    rm test/DebugInfo/X86/convert-inlined.ll
    rm test/DebugInfo/X86/convert-linked.ll
    rm test/tools/dsymutil/X86/op-convert.test
  '' + optionalString (stdenv.hostPlatform.system == "armv6l-linux") ''
    # Seems to require certain floating point hardware (NEON?)
    rm test/ExecutionEngine/frem.ll
  '' + ''
    patchShebangs test/BugPoint/compile-custom.ll.py
  '';

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_ENABLE_RTTI=ON"
    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_ENABLE_DUMP=ON"
  ] ++ optionals enableSharedLibraries [
    "-DLLVM_LINK_LLVM_DYLIB=ON"
  ] ++ optionals enableManpages [
    "-DLLVM_BUILD_DOCS=ON"
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ] ++ optionals (!isDarwin) [
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
  ] ++ optionals isDarwin [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DCAN_TARGET_i386=false"
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DCMAKE_CROSSCOMPILING=True"
    "-DLLVM_TABLEGEN=${buildPackages.llvm_10}/bin/llvm-tblgen"
  ];

  postBuild = ''
    rm -fR $out
  '';

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/lib
  '';

  postInstall = ''
    mkdir -p $python/share
    mv $out/share/opt-viewer $python/share/opt-viewer
  ''
  + optionalString enableSharedLibraries ''
    moveToOutput "lib/libLLVM-*" "$lib"
    moveToOutput "lib/libLLVM${stdenv.hostPlatform.extensions.sharedLibrary}" "$lib"
  ''
  + optionalString (enableSharedLibraries && (!stdenv.isDarwin)) ''
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-${if debugVersion then "debug" else "release"}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM-" "$lib/lib/libLLVM-"
  ''
  + optionalString (stdenv.isDarwin && enableSharedLibraries) ''
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-${if debugVersion then "debug" else "release"}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM.dylib" "$lib/lib/libLLVM.dylib"
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${shortVersion}.dylib
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${release_version}.dylib
  '';

  doCheck = stdenv.isLinux && (!stdenv.isx86_32);

  checkTarget = "check-all";

  enableParallelBuilding = true;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin dtzWill ];
    platforms   = stdenv.lib.platforms.all;
  };
} // stdenv.lib.optionalAttrs enableManpages {
  pname = "llvm-manpages";

  buildPhase = ''
    make docs-llvm-man
  '';

  propagatedBuildInputs = [];

  installPhase = ''
    make -C docs install
  '';

  postPatch = null;
  postInstall = null;

  outputs = [ "out" ];

  doCheck = false;

  meta.description = "man pages for LLVM ${version}";
})

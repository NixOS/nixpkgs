{ lib, stdenv, llvm_meta
, pkgsBuildBuild
, fetch
, fetchpatch
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
, buildLlvmTools
, debugVersion ? false
, enableManpages ? false
, enableSharedLibraries ? !stdenv.hostPlatform.isStatic
, enablePFM ? !(stdenv.isDarwin
  || stdenv.isAarch64 # broken for Ampere eMAG 8180 (c2.large.arm on Packet) #56245
  || stdenv.isAarch32 # broken for the armv7l builder
)
, enablePolly ? true
}:

let
  inherit (lib) optional optionals optionalString;

  # Used when creating a version-suffixed symlink of libLLVM.dylib
  shortVersion = with lib;
    concatStringsSep "." (take 1 (splitString "." release_version));

in stdenv.mkDerivation (rec {
  pname = "llvm";
  inherit version;

  src = fetch pname "1wydhbp9kyjp5y0rc627imxgkgqiv3dfirbqil9dgpnbaw5y7n65";
  polly_src = fetch "polly" "0nm2d8niz47yjsa3r17v3p13b70igkd338ib8191znr1dfw0pyyj";

  unpackPhase = ''
    unpackFile $src
    mv llvm-${version}* llvm
    sourceRoot=$PWD/llvm
  '' + optionalString enablePolly ''
    unpackFile $polly_src
    mv polly-* $sourceRoot/tools/polly
  '';

  outputs = [ "out" "lib" "dev" "python" ];

  nativeBuildInputs = [ cmake python3 ]
    ++ optionals enableManpages [ python3.pkgs.sphinx python3.pkgs.recommonmark ];

  buildInputs = [ libxml2 libffi ]
    ++ optional enablePFM libpfm; # exegesis

  propagatedBuildInputs = [ ncurses zlib ];

  patches = [
    ./gnu-install-dirs.patch
    # On older CPUs (e.g. Hydra/wendy) we'd be getting an error in this test.
    (fetchpatch {
      name = "uops-CMOV16rm-noreg.diff";
      url = "https://github.com/llvm/llvm-project/commit/9e9f991ac033.diff";
      sha256 = "sha256:12s8vr6ibri8b48h2z38f3afhwam10arfiqfy4yg37bmc054p5hi";
      stripLen = 1;
    })
  ] ++ lib.optional enablePolly ./gnu-install-dirs-polly.patch;

  postPatch = optionalString stdenv.isDarwin ''
    substituteInPlace cmake/modules/AddLLVM.cmake \
      --replace 'set(_install_name_dir INSTALL_NAME_DIR "@rpath")' "set(_install_name_dir)" \
      --replace 'set(_install_rpath "@loader_path/../''${CMAKE_INSTALL_LIBDIR}''${LLVM_LIBDIR_SUFFIX}" ''${extra_libdir})' ""
  ''
  # Patch llvm-config to return correct library path based on --link-{shared,static}.
  + optionalString (enableSharedLibraries) ''
    substitute '${./outputs.patch}' ./outputs.patch --subst-var lib
    patch -p1 < ./outputs.patch
  '' + ''
    # FileSystem permissions tests fail with various special bits
    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "Path.cpp" ""
    rm unittests/Support/Path.cpp
  '' + optionalString stdenv.hostPlatform.isMusl ''
    patch -p1 -i ${../../TLI-musl.patch}
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
    rm test/DebugInfo/X86/debug_addr.ll
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
    "-DLLVM_INSTALL_CMAKE_DIR=${placeholder "dev"}/lib/cmake/llvm/"
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
    "-DLLVM_TABLEGEN=${buildLlvmTools.llvm}/bin/llvm-tblgen"
    (
      let
        nativeCC = pkgsBuildBuild.targetPackages.stdenv.cc;
        nativeBintools = nativeCC.bintools.bintools;
        nativeToolchainFlags = [
          "-DCMAKE_C_COMPILER=${nativeCC}/bin/${nativeCC.targetPrefix}cc"
          "-DCMAKE_CXX_COMPILER=${nativeCC}/bin/${nativeCC.targetPrefix}c++"
          "-DCMAKE_AR=${nativeBintools}/bin/${nativeBintools.targetPrefix}ar"
          "-DCMAKE_STRIP=${nativeBintools}/bin/${nativeBintools.targetPrefix}strip"
          "-DCMAKE_RANLIB=${nativeBintools}/bin/${nativeBintools.targetPrefix}ranlib"
        ];
      in "-DCROSS_TOOLCHAIN_FLAGS_NATIVE:list=${lib.concatStringsSep ";" nativeToolchainFlags}"
    )
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
    moveToOutput "bin/llvm-config*" "$dev"
    substituteInPlace "$dev/lib/cmake/llvm/LLVMExports-${if debugVersion then "debug" else "release"}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/lib" "$lib/lib/lib" \
      --replace "$out/bin/llvm-config" "$dev/bin/llvm-config"
    substituteInPlace "$dev/lib/cmake/llvm/LLVMConfig.cmake" \
      --replace 'set(LLVM_BINARY_DIR "''${LLVM_INSTALL_PREFIX}")' 'set(LLVM_BINARY_DIR "''${LLVM_INSTALL_PREFIX}'"$lib"'")'
  ''
  + optionalString (stdenv.isDarwin && enableSharedLibraries) ''
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${shortVersion}.dylib
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${release_version}.dylib
  ''
  + optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    cp NATIVE/bin/llvm-config $dev/bin/llvm-config-native
  '';

  doCheck = stdenv.isLinux && (!stdenv.isx86_32);

  checkTarget = "check-all";

  requiredSystemFeatures = [ "big-parallel" ];
  meta = llvm_meta // {
    homepage = "https://llvm.org/";
    description = "A collection of modular and reusable compiler and toolchain technologies";
    longDescription = ''
      The LLVM Project is a collection of modular and reusable compiler and
      toolchain technologies. Despite its name, LLVM has little to do with
      traditional virtual machines. The name "LLVM" itself is not an acronym; it
      is the full name of the project.
      LLVM began as a research project at the University of Illinois, with the
      goal of providing a modern, SSA-based compilation strategy capable of
      supporting both static and dynamic compilation of arbitrary programming
      languages. Since then, LLVM has grown to be an umbrella project consisting
      of a number of subprojects, many of which are being used in production by
      a wide variety of commercial and open source projects as well as being
      widely used in academic research. Code in the LLVM project is licensed
      under the "Apache 2.0 License with LLVM exceptions".
    '';
  };
} // lib.optionalAttrs enableManpages {
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

  meta = llvm_meta // {
    description = "man pages for LLVM ${version}";
  };
})

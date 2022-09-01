{ lib, stdenv, llvm_meta
, pkgsBuildBuild
, fetch
, fetchpatch
, cmake
, python3
, libffi
, libbfd
, libxml2
, ncurses
, version
, release_version
, zlib
, buildLlvmTools
, debugVersion ? false
, enableManpages ? false
, enableSharedLibraries ? !enableManpages
, enablePolly ? false
}:

let
  inherit (lib) optional optionals optionalString;

  # Used when creating a versioned symlinks of libLLVM.dylib
  versionSuffixes = with lib;
    let parts = splitVersion release_version; in
    imap (i: _: concatStringsSep "." (take i parts)) parts;
in

stdenv.mkDerivation (rec {
  pname = "llvm";
  inherit version;

  src = fetch "llvm" "0g1bbj2n6xv4p1n6hh17vj3vpvg56wacipc81dgwga9mg2lys8nm";
  polly_src = fetch "polly" "1f4i1qsw7ywx25v262p8syz339zcbvfkx295xz26hmqrn944xa6x";

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
    ++ optional enableManpages python3.pkgs.sphinx;

  buildInputs = [ libxml2 libffi ];

  propagatedBuildInputs = [ ncurses zlib ];

  patches = [
    (fetchpatch {
      url = "https://bugzilla.redhat.com/attachment.cgi?id=1389687";
      name = "llvm-gcc8-type-mismatch.patch";
      sha256 = "0ga2123aclq3x9w72d0rm0az12m8c1i4r1106vh701hf4cghgbch";
    })
    ./fix-gcc9.patch
    #(fetchpatch {
    #  name = "llvm-fix-gcc9.patch";
    #  url = "https://reviews.llvm.org/file/data/zs3ck5ryvc5n672fd2kw/PHID-FILE-byoqefzwmkd7qnlip4v2/file";
    #  sha256 = "0injj1hqgrbcbihhwp2nbal88jfykad30r54f2cdcx7gws2fcy8i";
    #  stripLen = 1;
    #})

    # When cross-compiling we configure llvm-config-native with an approximation
    # of the flags used for the normal LLVM build. To avoid the need for building
    # a native libLLVM.so (which would fail) we force llvm-config to be linked
    # statically against the necessary LLVM components always.
    ../../llvm-config-link-static.patch

    ./gnu-install-dirs.patch

    # Fix invalid std::string(nullptr) for GCC 12
    (fetchpatch {
      name = "nvptx-gcc-12.patch";
      url = "https://github.com/llvm/llvm-project/commit/99e64623ec9b31def9375753491cc6093c831809.patch";
      sha256 = "0zjfjgavqzi2ypqwqnlvy6flyvdz8hi1anwv0ybwnm2zqixg7za3";
      stripLen = 1;
    })
  ] ++ lib.optional enablePolly ./gnu-install-dirs-polly.patch;

  postPatch = optionalString stdenv.isDarwin ''
    substituteInPlace cmake/modules/AddLLVM.cmake \
      --replace 'set(_install_name_dir INSTALL_NAME_DIR "@rpath")' "set(_install_name_dir)" \
      --replace 'set(_install_rpath "@loader_path/../''${CMAKE_INSTALL_LIBDIR}" ''${extra_libdir})' ""
  '' + ''
    # FileSystem permissions tests fail with various special bits
    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "Path.cpp" ""
    rm unittests/Support/Path.cpp

    # llvm-5 does not support dwarf-5 style info, fails on gcc-11.
    rm test/tools/llvm-symbolizer/print_context.c
  '' + optionalString stdenv.isAarch64 ''
    patch -p0 < ${../../aarch64.patch}
  '' + optionalString stdenv.hostPlatform.isMusl ''
    patch -p1 -i ${../../TLI-musl.patch}
    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "add_subdirectory(DynamicLibrary)" ""
    rm unittests/Support/DynamicLibrary/DynamicLibraryTest.cpp
  '' + ''
    # Tweak tests to ignore namespace part of type to support
    # gcc-12: https://gcc.gnu.org/PR103598.
    # The change below mangles strings like:
    #    CHECK-NEXT: Starting llvm::Function pass manager run.
    # to:
    #    CHECK-NEXT: Starting {{.*}}Function pass manager run.
    for f in \
      test/Other/new-pass-manager.ll \
      test/Other/new-pm-defaults.ll \
      test/Other/new-pm-lto-defaults.ll \
      test/Other/new-pm-thinlto-defaults.ll \
      test/Other/pass-pipeline-parsing.ll \
      test/Transforms/Inline/cgscc-incremental-invalidate.ll \
      test/Transforms/Inline/clear-analyses.ll \
      ; do
      echo "PATCH: $f"
      substituteInPlace $f \
        --replace 'Starting llvm::' 'Starting {{.*}}' \
        --replace 'Finished llvm::' 'Finished {{.*}}'
    done
  '';

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  cmakeFlags = with stdenv; let
    # These flags influence llvm-config's BuildVariables.inc in addition to the
    # general build. We need to make sure these are also passed via
    # CROSS_TOOLCHAIN_FLAGS_NATIVE when cross-compiling or llvm-config-native
    # will return different results from the cross llvm-config.
    #
    # Some flags don't need to be repassed because LLVM already does so (like
    # CMAKE_BUILD_TYPE), others are irrelevant to the result.
    flagsForLlvmConfig = [
      "-DLLVM_INSTALL_CMAKE_DIR=${placeholder "dev"}/lib/cmake/llvm/"
      "-DLLVM_ENABLE_RTTI=ON"
    ] ++ optionals enableSharedLibraries [
      "-DLLVM_LINK_LLVM_DYLIB=ON"
    ];
  in flagsForLlvmConfig ++ [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=${lib.boolToCMakeString doCheck}"
    "-DLLVM_ENABLE_FFI=ON"

    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.hostPlatform.config}"
    "-DTARGET_TRIPLE=${stdenv.hostPlatform.config}"
  ]
  ++ lib.optionals enableManpages [
    "-DLLVM_BUILD_DOCS=ON"
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ]
  ++ lib.optional (!isDarwin)
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
  ++ lib.optionals (isDarwin) [
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
        # We need to repass the custom GNUInstallDirs values, otherwise CMake
        # will choose them for us, leading to wrong results in llvm-config-native
        nativeInstallFlags = [
          "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
          "-DCMAKE_INSTALL_BINDIR=${placeholder "out"}/bin"
          "-DCMAKE_INSTALL_INCLUDEDIR=${placeholder "dev"}/include"
          "-DCMAKE_INSTALL_LIBDIR=${placeholder "lib"}/lib"
          "-DCMAKE_INSTALL_LIBEXECDIR=${placeholder "lib"}/libexec"
        ];
      in "-DCROSS_TOOLCHAIN_FLAGS_NATIVE:list="
      + lib.concatStringsSep ";" (lib.concatLists [
        flagsForLlvmConfig
        nativeToolchainFlags
        nativeInstallFlags
      ])
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
    ${lib.concatMapStringsSep "\n" (v: ''
      ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${v}.dylib
    '') versionSuffixes}
  ''
  + optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    cp NATIVE/bin/llvm-config $dev/bin/llvm-config-native
  '';

  doCheck = stdenv.isLinux && (!stdenv.isi686)
    && (stdenv.hostPlatform == stdenv.buildPlatform);

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

  outputs = [ "out" ];

  doCheck = false;

  meta = llvm_meta // {
    description = "man pages for LLVM ${version}";
  };
})

{ lib, stdenv, llvm_meta
, pkgsBuildBuild
, fetch
, fetchpatch
, cmake
, python3
, libffi
, enableGoldPlugin ? libbfd.hasPluginAPI
, libbfd
, libpfm
, libxml2
, ncurses
, version
, release_version
, zlib
, buildLlvmTools
, debugVersion ? false
, doCheck ? stdenv.isLinux && (!stdenv.isx86_32) && (!stdenv.hostPlatform.isMusl) && (!stdenv.hostPlatform.isRiscV)
  && (stdenv.hostPlatform == stdenv.buildPlatform)
, enableManpages ? false
, enableSharedLibraries ? !stdenv.hostPlatform.isStatic
# broken for Ampere eMAG 8180 (c2.large.arm on Packet) #56245
# broken for the armv7l builder
, enablePFM ? stdenv.isLinux && !stdenv.hostPlatform.isAarch
, enablePolly ? false # TODO should be on by default
}:

let
  inherit (lib) optional optionals optionalString;

  # Used when creating a version-suffixed symlink of libLLVM.dylib
  shortVersion = with lib;
    concatStringsSep "." (take 1 (splitString "." release_version));

  # Ordinarily we would just the `doCheck` and `checkDeps` functionality
  # `mkDerivation` gives us to manage our test dependencies (instead of breaking
  # out `doCheck` as a package level attribute).
  #
  # Unfortunately `lit` does not forward `$PYTHONPATH` to children processes, in
  # particular the children it uses to do feature detection.
  #
  # This means that python deps we add to `checkDeps` (which the python
  # interpreter is made aware of via `$PYTHONPATH` – populated by the python
  # setup hook) are not picked up by `lit` which causes it to skip tests.
  #
  # Adding `python3.withPackages (ps: [ ... ])` to `checkDeps` also doesn't work
  # because this package is shadowed in `$PATH` by the regular `python3`
  # package.
  #
  # So, we "manually" assemble one python derivation for the package to depend
  # on, taking into account whether checks are enabled or not:
  python = if doCheck then
    let
      checkDeps = ps: with ps; [ psutil ];
    in python3.withPackages checkDeps
  else python3;

in stdenv.mkDerivation (rec {
  pname = "llvm";
  inherit version;

  src = fetch pname "199yq3a214avcbi4kk2q0ajriifkvsr0l2dkx3a666m033ihi1ff";
  polly_src = fetch "polly" "031r23ijhx7v93a5n33m2nc0x9xyqmx0d8xg80z7q971p6qd63sq";

  unpackPhase = ''
    unpackFile $src
    mv llvm-${release_version}* llvm
    sourceRoot=$PWD/llvm
  '' + optionalString enablePolly ''
    unpackFile $polly_src
    mv polly-* $sourceRoot/tools/polly
  '';

  outputs = [ "out" "lib" "dev" "python" ];

  nativeBuildInputs = [ cmake python ]
    ++ optionals enableManpages [ python3.pkgs.sphinx python3.pkgs.recommonmark ];

  buildInputs = [ libxml2 libffi ]
    ++ optional enablePFM libpfm; # exegesis

  propagatedBuildInputs = [ ncurses zlib ];

  patches = [
    # When cross-compiling we configure llvm-config-native with an approximation
    # of the flags used for the normal LLVM build. To avoid the need for building
    # a native libLLVM.so (which would fail) we force llvm-config to be linked
    # statically against the necessary LLVM components always.
    ../../llvm-config-link-static.patch

    ./gnu-install-dirs.patch
    # On older CPUs (e.g. Hydra/wendy) we'd be getting an error in this test.
    (fetchpatch {
      name = "uops-CMOV16rm-noreg.diff";
      url = "https://github.com/llvm/llvm-project/commit/9e9f991ac033.diff";
      sha256 = "sha256:12s8vr6ibri8b48h2z38f3afhwam10arfiqfy4yg37bmc054p5hi";
      stripLen = 1;
    })
    # gcc-11 compat upstream patch
    (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/b498303066a63a203d24f739b2d2e0e56dca70d1.patch";
      sha256 = "sha256:0nh123kld0dgz2h941lng331dkj3wbm5lfxm375k1f569gv83hlk";
      stripLen = 1;
    })

    # Fix invalid std::string(nullptr) for GCC 12
    (fetchpatch {
      name = "nvptx-gcc-12.patch";
      url = "https://github.com/llvm/llvm-project/commit/99e64623ec9b31def9375753491cc6093c831809.patch";
      sha256 = "0zjfjgavqzi2ypqwqnlvy6flyvdz8hi1anwv0ybwnm2zqixg7za3";
      stripLen = 1;
    })
    (fetchpatch {
      name = "dfaemitter-gcc-12.patch";
      url = "https://github.com/llvm/llvm-project/commit/0841916e87a39e3c223c986e8da31e4a9a1432e3.patch";
      sha256 = "1kckghvsngs51mqm82asy0s9vr19h8aqbw43a0w44mccqw6bzrwf";
      stripLen = 1;
    })

    # Fix musl build.
    (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/5cd554303ead0f8891eee3cd6d25cb07f5a7bf67.patch";
      relative = "llvm";
      hash = "sha256-XPbvNJ45SzjMGlNUgt/IgEvM2dHQpDOe6woUJY+nUYA=";
    })

    # Backport gcc-13 fixes with missing includes.
    (fetchpatch {
      name = "signals-gcc-13.patch";
      url = "https://github.com/llvm/llvm-project/commit/ff1681ddb303223973653f7f5f3f3435b48a1983.patch";
      hash = "sha256-CXwYxQezTq5vdmc8Yn88BUAEly6YZ5VEIA6X3y5NNOs=";
      stripLen = 1;
    })
    (fetchpatch {
      name = "base64-gcc-13.patch";
      url = "https://github.com/llvm/llvm-project/commit/5e9be93566f39ee6cecd579401e453eccfbe81e5.patch";
      hash = "sha256-PAwrVrvffPd7tphpwCkYiz+67szPRzRB2TXBvKfzQ7U=";
      stripLen = 1;
    })
  ] ++ lib.optional enablePolly ./gnu-install-dirs-polly.patch;

  postPatch = optionalString stdenv.isDarwin ''
    substituteInPlace cmake/modules/AddLLVM.cmake \
      --replace 'set(_install_name_dir INSTALL_NAME_DIR "@rpath")' "set(_install_name_dir)" \
      --replace 'set(_install_rpath "@loader_path/../''${CMAKE_INSTALL_LIBDIR}''${LLVM_LIBDIR_SUFFIX}" ''${extra_libdir})' ""
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
    rm test/tools/dsymutil/X86/op-convert.test
    rm test/tools/gold/X86/split-dwarf.ll
    rm test/tools/llvm-readobj/ELF/dependent-libraries.test
  '' + optionalString (stdenv.hostPlatform.system == "armv6l-linux") ''
    # Seems to require certain floating point hardware (NEON?)
    rm test/ExecutionEngine/frem.ll
  '' + ''
    patchShebangs test/BugPoint/compile-custom.ll.py
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
      test/Transforms/LoopUnroll/unroll-loop-invalidation.ll \
      test/Transforms/SCCP/ipsccp-preserve-analysis.ll \
      test/Transforms/SCCP/preserve-analysis.ll \
      test/Transforms/SROA/dead-inst.ll \
      test/tools/gold/X86/new-pm.ll \
      ; do
      echo "PATCH: $f"
      substituteInPlace $f \
        --replace 'Starting llvm::' 'Starting {{.*}}' \
        --replace 'Finished llvm::' 'Finished {{.*}}'
    done
  '';

  preConfigure = ''
    # Workaround for configure flags that need to have spaces
    cmakeFlagsArray+=(
      -DLLVM_LIT_ARGS='-svj''${NIX_BUILD_CORES} --no-progress-bar'
    )
  '';

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  # E.g. mesa.drivers use the build-id as a cache key (see #93946):
  LDFLAGS = optionalString (enableSharedLibraries && !stdenv.isDarwin) "-Wl,--build-id=sha1";

  cmakeBuildType = if debugVersion then "Debug" else "Release";

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
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=${if doCheck then "ON" else "OFF"}"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_ENABLE_DUMP=ON"
  ] ++ optionals stdenv.hostPlatform.isStatic [
    # Disables building of shared libs, -fPIC is still injected by cc-wrapper
    "-DLLVM_ENABLE_PIC=OFF"
    "-DLLVM_BUILD_STATIC=ON"
    # libxml2 needs to be disabled because the LLVM build system ignores its .la
    # file and doesn't link zlib as well.
    # https://github.com/ClangBuiltLinux/tc-build/issues/150#issuecomment-845418812
    "-DLLVM_ENABLE_LIBXML2=OFF"
    # This is a Shared Library not tied to LLVM_ENABLE_PIC
    "-DLLVM_TOOL_REMARKS_SHLIB_BUILD=OFF"
  ] ++ optionals enableManpages [
    "-DLLVM_BUILD_DOCS=ON"
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ] ++ optionals (enableGoldPlugin) [
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
  ] ++ optionals isDarwin [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DCAN_TARGET_i386=false"
  ] ++ optionals ((stdenv.hostPlatform != stdenv.buildPlatform) && !(stdenv.buildPlatform.canExecute stdenv.hostPlatform)) [
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
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${shortVersion}.dylib
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${release_version}.dylib
  ''
  + optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    cp NATIVE/bin/llvm-config $dev/bin/llvm-config-native
  '';

  inherit doCheck;

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

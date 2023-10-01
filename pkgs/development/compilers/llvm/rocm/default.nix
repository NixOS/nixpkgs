{ lib
, stdenv
, callPackage
, overrideCC
, wrapCCWith
, wrapBintoolsWith
, runCommand
, lit
, glibc
, spirv-llvm-translator
, xz
, swig
, lua5_3
, gtest
, hip
, rocm-comgr
, vulkan-loader
, vulkan-headers
, glslang
, shaderc
, perl
, rocm-device-libs
, rocm-runtime
, elfutils
, graphviz
, python3Packages
}:

let
  # Stage 1
  # Base
  llvm = callPackage ./llvm.nix {
    requiredSystemFeatures = [ "big-parallel" ];
    isBroken = stdenv.isAarch64; # https://github.com/RadeonOpenCompute/ROCm/issues/1831#issuecomment-1278205344
  };

  # Projects
  clang-unwrapped = callPackage ./llvm.nix rec {
    targetName = "clang";
    targetDir = targetName;
    extraBuildInputs = [ llvm ];

    extraCMakeFlags = [
      "-DCLANG_INCLUDE_DOCS=ON"
      "-DCLANG_INCLUDE_TESTS=ON"
    ];

    extraPostPatch = ''
      # Looks like they forgot to add finding libedit to the standalone build
      ln -s ../cmake/Modules/FindLibEdit.cmake cmake/modules

      substituteInPlace CMakeLists.txt \
        --replace "include(CheckIncludeFile)" "include(CheckIncludeFile)''\nfind_package(LibEdit)"

      # `No such file or directory: '/build/source/clang/tools/scan-build/bin/scan-build'`
      rm test/Analysis/scan-build/*.test
      rm test/Analysis/scan-build/rebuild_index/rebuild_index.test

      # `does not depend on a module exporting 'baz.h'`
      rm test/Modules/header-attribs.cpp

      # We do not have HIP or the ROCm stack available yet
      rm test/Driver/hip-options.hip

      # ???? `ld: cannot find crti.o: No such file or directory` linker issue?
      rm test/Interpreter/dynamic-library.cpp

      # `fatal error: 'stdio.h' file not found`
      rm test/OpenMP/amdgcn_emit_llvm.c
    '';

    extraPostInstall = ''
      mv bin/clang-tblgen $out/bin
    '';

    requiredSystemFeatures = [ "big-parallel" ];
  };

  lld = callPackage ./llvm.nix rec {
    buildMan = false; # No man pages to build
    targetName = "lld";
    targetDir = targetName;
    extraBuildInputs = [ llvm ];
    checkTargets = [ "check-${targetName}" ];
  };

  # Runtimes
  runtimes = callPackage ./llvm.nix rec {
    buildDocs = false;
    buildMan = false;
    buildTests = false;
    targetName = "runtimes";
    targetDir = targetName;

    targetRuntimes = [
      "libunwind"
      "libcxxabi"
      "libcxx"
      "compiler-rt"
    ];

    extraBuildInputs = [ llvm ];

    extraCMakeFlags = [
      "-DLIBCXX_INCLUDE_BENCHMARKS=OFF"
      "-DLIBCXX_CXX_ABI=libcxxabi"
    ];

    extraLicenses = [ lib.licenses.mit ];
  };

  # Stage 2
  # Helpers
  rStdenv = overrideCC stdenv (wrapCCWith rec {
    inherit bintools;
    libcxx = runtimes;
    cc = clang-unwrapped;

    extraPackages = [
      llvm
      lld
    ];

    nixSupport.cc-cflags = [
      "-resource-dir=$out/resource-root"
      "-fuse-ld=lld"
      "-rtlib=compiler-rt"
      "-unwindlib=libunwind"
      "-Wno-unused-command-line-argument"
    ];

    extraBuildCommands = ''
      clang_version=`${cc}/bin/clang -v 2>&1 | grep "clang version " | grep -E -o "[0-9.-]+"`
      mkdir -p $out/resource-root
      ln -s ${cc}/lib/clang/$clang_version/include $out/resource-root
      ln -s ${runtimes}/lib $out/resource-root
    '';
  });

  bintools = wrapBintoolsWith { bintools = bintools-unwrapped; };

  bintools-unwrapped = runCommand "rocm-llvm-binutils-${llvm.version}" { preferLocalBuild = true; } ''
    mkdir -p $out/bin

    for prog in ${lld}/bin/*; do
      ln -s $prog $out/bin/$(basename $prog)
    done

    for prog in ${llvm}/bin/*; do
      ln -sf $prog $out/bin/$(basename $prog)
    done

    ln -s ${llvm}/bin/llvm-ar $out/bin/ar
    ln -s ${llvm}/bin/llvm-as $out/bin/as
    ln -s ${llvm}/bin/llvm-dwp $out/bin/dwp
    ln -s ${llvm}/bin/llvm-nm $out/bin/nm
    ln -s ${llvm}/bin/llvm-objcopy $out/bin/objcopy
    ln -s ${llvm}/bin/llvm-objdump $out/bin/objdump
    ln -s ${llvm}/bin/llvm-ranlib $out/bin/ranlib
    ln -s ${llvm}/bin/llvm-readelf $out/bin/readelf
    ln -s ${llvm}/bin/llvm-size $out/bin/size
    ln -s ${llvm}/bin/llvm-strip $out/bin/strip
    ln -s ${lld}/bin/lld $out/bin/ld
  '';
in rec {
  inherit
  llvm
  clang-unwrapped
  lld
  bintools
  bintools-unwrapped;

  # Runtimes
  libc = callPackage ./llvm.nix rec {
    stdenv = rStdenv;
    buildMan = false; # No man pages to build
    targetName = "libc";
    targetDir = "runtimes";
    targetRuntimes = [ targetName ];

    extraPostPatch = ''
      # `Failed to match ... against ...` `Match value not within tolerance value of MPFR result:`
      # We need a better way, but I don't know enough sed magic and patching `CMakeLists.txt` isn't working...
      substituteInPlace ../libc/test/src/math/log10_test.cpp \
        --replace "i < N" "i < 0" \
        --replace "test(mpfr::RoundingMode::Nearest);" "" \
        --replace "test(mpfr::RoundingMode::Downward);" "" \
        --replace "test(mpfr::RoundingMode::Upward);" "" \
        --replace "test(mpfr::RoundingMode::TowardZero);" ""
    '';

    checkTargets = [ "check-${targetName}" ];
    hardeningDisable = [ "fortify" ]; # Prevent `error: "Assumed value of MB_LEN_MAX wrong"`
  };

  libunwind = callPackage ./llvm.nix rec {
    stdenv = rStdenv;
    buildMan = false; # No man pages to build
    targetName = "libunwind";
    targetDir = "runtimes";
    targetRuntimes = [ targetName ];

    extraCMakeFlags = [
      "-DLIBUNWIND_INCLUDE_DOCS=ON"
      "-DLIBUNWIND_INCLUDE_TESTS=ON"
      "-DLIBUNWIND_USE_COMPILER_RT=ON"
    ];

    extraPostPatch = ''
      # `command had no output on stdout or stderr` (Says these unsupported tests)
      chmod +w -R ../libunwind/test
      rm ../libunwind/test/floatregister.pass.cpp
      rm ../libunwind/test/unwind_leaffunction.pass.cpp
      rm ../libunwind/test/libunwind_02.pass.cpp
    '';
  };

  libcxxabi = callPackage ./llvm.nix rec {
    stdenv = rStdenv;
    buildDocs = false; # No documentation to build
    buildMan = false; # No man pages to build
    targetName = "libcxxabi";
    targetDir = "runtimes";

    targetRuntimes = [
      "libunwind"
      targetName
      "libcxx"
    ];

    extraCMakeFlags = [
      "-DLIBCXXABI_INCLUDE_TESTS=ON"
      "-DLIBCXXABI_USE_LLVM_UNWINDER=ON"
      "-DLIBCXXABI_USE_COMPILER_RT=ON"

      # Workaround having to build combined
      "-DLIBUNWIND_INCLUDE_DOCS=OFF"
      "-DLIBUNWIND_INCLUDE_TESTS=OFF"
      "-DLIBUNWIND_USE_COMPILER_RT=ON"
      "-DLIBUNWIND_INSTALL_LIBRARY=OFF"
      "-DLIBUNWIND_INSTALL_HEADERS=OFF"
      "-DLIBCXX_INCLUDE_DOCS=OFF"
      "-DLIBCXX_INCLUDE_TESTS=OFF"
      "-DLIBCXX_USE_COMPILER_RT=ON"
      "-DLIBCXX_CXX_ABI=libcxxabi"
      "-DLIBCXX_INSTALL_LIBRARY=OFF"
      "-DLIBCXX_INSTALL_HEADERS=OFF"
    ];
  };

  libcxx = callPackage ./llvm.nix rec {
    stdenv = rStdenv;
    buildMan = false; # No man pages to build
    targetName = "libcxx";
    targetDir = "runtimes";

    targetRuntimes = [
      "libunwind"
      "libcxxabi"
      targetName
    ];

    extraCMakeFlags = [
      "-DLIBCXX_INCLUDE_DOCS=ON"
      "-DLIBCXX_INCLUDE_TESTS=ON"
      "-DLIBCXX_USE_COMPILER_RT=ON"
      "-DLIBCXX_CXX_ABI=libcxxabi"

      # Workaround having to build combined
      "-DLIBUNWIND_INCLUDE_DOCS=OFF"
      "-DLIBUNWIND_INCLUDE_TESTS=OFF"
      "-DLIBUNWIND_USE_COMPILER_RT=ON"
      "-DLIBUNWIND_INSTALL_LIBRARY=OFF"
      "-DLIBUNWIND_INSTALL_HEADERS=OFF"
      "-DLIBCXXABI_INCLUDE_TESTS=OFF"
      "-DLIBCXXABI_USE_LLVM_UNWINDER=ON"
      "-DLIBCXXABI_USE_COMPILER_RT=ON"
      "-DLIBCXXABI_INSTALL_LIBRARY=OFF"
      "-DLIBCXXABI_INSTALL_HEADERS=OFF"
    ];

    # Most of these can't find `bash` or `mkdir`, might just be hard-coded paths, or PATH is altered
    extraPostPatch = ''
      chmod +w -R ../libcxx/test/{libcxx,std}
      cat ${./1000-libcxx-failing-tests.list} | xargs -d \\n rm
    '';
  };

  compiler-rt = callPackage ./llvm.nix rec {
    stdenv = rStdenv;
    buildDocs = false; # No documentation to build
    buildMan = false; # No man pages to build
    targetName = "compiler-rt";
    targetDir = "runtimes";

    targetRuntimes = [
      "libunwind"
      "libcxxabi"
      "libcxx"
      targetName
    ];

    extraCMakeFlags = [
      "-DCOMPILER_RT_INCLUDE_TESTS=ON"
      "-DCOMPILER_RT_USE_LLVM_UNWINDER=ON"
      "-DCOMPILER_RT_CXX_LIBRARY=libcxx"
      "-DCOMPILER_RT_CAN_EXECUTE_TESTS=OFF" # We can't run most of these

      # Workaround having to build combined
      "-DLIBUNWIND_INCLUDE_DOCS=OFF"
      "-DLIBUNWIND_INCLUDE_TESTS=OFF"
      "-DLIBUNWIND_USE_COMPILER_RT=ON"
      "-DLIBUNWIND_INSTALL_LIBRARY=OFF"
      "-DLIBUNWIND_INSTALL_HEADERS=OFF"
      "-DLIBCXXABI_INCLUDE_TESTS=OFF"
      "-DLIBCXXABI_USE_LLVM_UNWINDER=ON"
      "-DLIBCXXABI_USE_COMPILER_RT=ON"
      "-DLIBCXXABI_INSTALL_LIBRARY=OFF"
      "-DLIBCXXABI_INSTALL_HEADERS=OFF"
      "-DLIBCXX_INCLUDE_DOCS=OFF"
      "-DLIBCXX_INCLUDE_TESTS=OFF"
      "-DLIBCXX_USE_COMPILER_RT=ON"
      "-DLIBCXX_CXX_ABI=libcxxabi"
      "-DLIBCXX_INSTALL_LIBRARY=OFF"
      "-DLIBCXX_INSTALL_HEADERS=OFF"
    ];

    extraPostPatch = ''
      # `No such file or directory: 'ldd'`
      substituteInPlace ../compiler-rt/test/lit.common.cfg.py \
        --replace "'ldd'," "'${glibc.bin}/bin/ldd',"

      # We can run these
      substituteInPlace ../compiler-rt/test/CMakeLists.txt \
        --replace "endfunction()" "endfunction()''\nadd_subdirectory(builtins)''\nadd_subdirectory(shadowcallstack)"

      # Could not launch llvm-config in /build/source/runtimes/build/bin
      mkdir -p build/bin
      ln -s ${llvm}/bin/llvm-config build/bin
    '';

    extraLicenses = [ lib.licenses.mit ];
  };

  # Stage 3
  # Helpers
  rocmClangStdenv = overrideCC stdenv clang;

  clang = wrapCCWith rec {
    inherit libcxx bintools;

    # We do this to avoid HIP pathing problems, and mimic a monolithic install
    cc = stdenv.mkDerivation (finalAttrs: {
      inherit (clang-unwrapped) pname version;
      dontUnpack = true;

      installPhase = ''
        runHook preInstall

        clang_version=`${clang-unwrapped}/bin/clang -v 2>&1 | grep "clang version " | grep -E -o "[0-9.-]+"`
        mkdir -p $out/{bin,include/c++/v1,lib/{cmake,clang/$clang_version/{include,lib}},libexec,share}

        for path in ${llvm} ${clang-unwrapped} ${lld} ${libc} ${libunwind} ${libcxxabi} ${libcxx} ${compiler-rt}; do
          cp -as $path/* $out
          chmod +w $out/{*,include/c++/v1,lib/{clang/$clang_version/include,cmake}}
          rm -f $out/lib/libc++.so
        done

        ln -s $out/lib/* $out/lib/clang/$clang_version/lib
        ln -sf $out/include/* $out/lib/clang/$clang_version/include

        runHook postInstall
      '';

      passthru.isClang = true;
    });

    extraPackages = [
      llvm
      lld
      libc
      libunwind
      libcxxabi
      compiler-rt
    ];

    nixSupport.cc-cflags = [
      "-resource-dir=$out/resource-root"
      "-fuse-ld=lld"
      "-rtlib=compiler-rt"
      "-unwindlib=libunwind"
      "-Wno-unused-command-line-argument"
    ];

    extraBuildCommands = ''
      clang_version=`${cc}/bin/clang -v 2>&1 | grep "clang version " | grep -E -o "[0-9.-]+"`
      mkdir -p $out/resource-root
      ln -s ${cc}/lib/clang/$clang_version/{include,lib} $out/resource-root

      # Not sure why, but hardening seems to make things break
      echo "" > $out/nix-support/add-hardening.sh

      # GPU compilation uses builtin `lld`
      substituteInPlace $out/bin/{clang,clang++} \
        --replace "-MM) dontLink=1 ;;" "-MM | --cuda-device-only) dontLink=1 ;;''\n--cuda-host-only | --cuda-compile-host-device) dontLink=0 ;;"
    '';
  };

  # Base
  # Unfortunately, we cannot build `clang-tools-extra` separately.
  clang-tools-extra = callPackage ./llvm.nix {
    stdenv = rocmClangStdenv;
    buildTests = false; # `invalid operands to binary expression ('std::basic_stringstream<char>' and 'const llvm::StringRef')`
    targetName = "clang-tools-extra";

    targetProjects = [
      "clang"
      "clang-tools-extra"
    ];

    extraBuildInputs = [ gtest ];

    extraCMakeFlags = [
      "-DLLVM_INCLUDE_DOCS=OFF"
      "-DLLVM_INCLUDE_TESTS=OFF"
      "-DCLANG_INCLUDE_DOCS=OFF"
      "-DCLANG_INCLUDE_TESTS=ON"
      "-DCLANG_TOOLS_EXTRA_INCLUDE_DOCS=ON"
    ];

    extraPostInstall = ''
      # Remove LLVM and Clang
      for path in `find ${llvm} ${clang-unwrapped}`; do
        if [ $path != ${llvm} ] && [ $path != ${clang-unwrapped} ]; then
          rm -f $out''${path#${llvm}} $out''${path#${clang-unwrapped}} || true
        fi
      done

      # Cleanup empty directories
      find $out -type d -empty -delete
    '';

    requiredSystemFeatures = [ "big-parallel" ];
  };

  # Projects
  libclc = let
    spirv = (spirv-llvm-translator.override { inherit llvm; });
  in callPackage ./llvm.nix rec {
    stdenv = rocmClangStdenv;
    buildDocs = false; # No documentation to build
    buildMan = false; # No man pages to build
    targetName = "libclc";
    targetDir = targetName;
    extraBuildInputs = [ spirv ];

    # `spirv-mesa3d` isn't compiling with LLVM 15.0.0, it does with LLVM 14.0.0
    # Try removing the `spirv-mesa3d` and `clspv` patches next update
    # `clspv` tests fail, unresolved calls
    extraPostPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace "find_program( LLVM_CLANG clang PATHS \''${LLVM_BINDIR} NO_DEFAULT_PATH )" \
          "find_program( LLVM_CLANG clang PATHS \"${clang}/bin\" NO_DEFAULT_PATH )" \
        --replace "find_program( LLVM_SPIRV llvm-spirv PATHS \''${LLVM_BINDIR} NO_DEFAULT_PATH )" \
          "find_program( LLVM_SPIRV llvm-spirv PATHS \"${spirv}/bin\" NO_DEFAULT_PATH )" \
        --replace "  spirv-mesa3d-" "" \
        --replace "  spirv64-mesa3d-" "" \
        --replace "NOT \''${t} MATCHES" \
          "NOT \''${ARCH} STREQUAL \"clspv\" AND NOT \''${ARCH} STREQUAL \"clspv64\" AND NOT \''${t} MATCHES"
    '';

    checkTargets = [ ];
    isBroken = true; # ROCm 5.7.0 doesn't have IR/AttributeMask.h yet...?
  };

  lldb = callPackage ./llvm.nix rec {
    stdenv = rocmClangStdenv;
    buildTests = false; # ld.lld: error: unable to find library -lllvm_gtest_main
    targetName = "lldb";
    targetDir = targetName;
    extraNativeBuildInputs = [ python3Packages.sphinx-automodapi ];

    extraBuildInputs = [
      xz
      swig
      lua5_3
      gtest
      graphviz
    ];

    extraCMakeFlags = [
      "-DLLDB_EXTERNAL_CLANG_RESOURCE_DIR=${clang}/resource-root/lib/clang/$clang_version"
      "-DLLDB_INCLUDE_TESTS=ON"
      "-DLLDB_INCLUDE_UNITTESTS=ON"
    ];

    extraPostPatch = ''
      export clang_version=`clang -v 2>&1 | grep "clang version " | grep -E -o "[0-9.-]+"`
    '';

    checkTargets = [ "check-${targetName}" ];
  };

  mlir = callPackage ./llvm.nix rec {
    stdenv = rocmClangStdenv;
    buildDocs = false; # No decent way to hack this to work
    buildMan = false; # No man pages to build
    targetName = "mlir";
    targetDir = targetName;
    extraNativeBuildInputs = [ hip ];

    extraBuildInputs = [
      rocm-comgr
      vulkan-headers
      vulkan-loader
      glslang
      shaderc
    ];

    extraCMakeFlags = [
      "-DCMAKE_POLICY_DEFAULT_CMP0116=NEW"
      "-DMLIR_INCLUDE_DOCS=ON"
      "-DMLIR_INCLUDE_TESTS=ON"
      "-DMLIR_ENABLE_ROCM_RUNNER=ON"
      "-DMLIR_ENABLE_SPIRV_CPU_RUNNER=ON"
      "-DMLIR_ENABLE_VULKAN_RUNNER=ON"
      "-DROCM_TEST_CHIPSET=gfx000" # CPU runner
    ];

    extraPostPatch = ''
      chmod +w ../llvm
      mkdir -p ../llvm/build/bin
      ln -s ${lit}/bin/lit ../llvm/build/bin/llvm-lit

      substituteInPlace test/CMakeLists.txt \
        --replace "FileCheck count not" "" \
        --replace "list(APPEND MLIR_TEST_DEPENDS mlir_rocm_runtime)" ""

      substituteInPlace lib/ExecutionEngine/CMakeLists.txt \
        --replace "return()" ""

      # Remove problematic tests
      rm test/CAPI/execution_engine.c
      rm test/Target/LLVMIR/llvmir-intrinsics.mlir
      rm test/Target/LLVMIR/llvmir.mlir
      rm test/Target/LLVMIR/openmp-llvm.mlir
      rm test/mlir-cpu-runner/*.mlir
      rm test/mlir-vulkan-runner/*.mlir
    '';

    extraPostInstall = ''
      mkdir -p $out/bin
      mv bin/mlir-tblgen $out/bin
    '';

    checkTargets = [ "check-${targetName}" ];
    requiredSystemFeatures = [ "big-parallel" ];
  };

  polly = callPackage ./llvm.nix rec {
    stdenv = rocmClangStdenv;
    targetName = "polly";
    targetDir = targetName;

    extraPostPatch = ''
      # `add_library cannot create target "llvm_gtest" because an imported target with the same name already exists`
      substituteInPlace CMakeLists.txt \
        --replace "NOT TARGET gtest" "FALSE"
    '';

    checkTargets = [ "check-${targetName}" ];
  };

  flang = callPackage ./llvm.nix rec {
    stdenv = rocmClangStdenv;
    buildTests = false; # `Executable "flang1" doesn't exist!`
    targetName = "flang";
    targetDir = targetName;
    extraNativeBuildInputs = [ python3Packages.sphinx-markdown-tables ];
    extraBuildInputs = [ mlir ];

    extraCMakeFlags = [
      "-DCMAKE_POLICY_DEFAULT_CMP0116=NEW"
      "-DCLANG_DIR=${clang-unwrapped}/lib/cmake/clang"
      "-DFLANG_INCLUDE_TESTS=OFF"
      "-DMLIR_TABLEGEN_EXE=${mlir}/bin/mlir-tblgen"
    ];

    extraPostPatch = ''
      substituteInPlace test/CMakeLists.txt \
        --replace "FileCheck" "" \
        --replace "count" "" \
        --replace "not" ""

      substituteInPlace docs/CMakeLists.txt \
        --replace "CLANG_TABLEGEN_EXE clang-tblgen" "CLANG_TABLEGEN_EXE ${clang-unwrapped}/bin/clang-tblgen"
    '';
  };

  openmp = callPackage ./llvm.nix rec {
    stdenv = rocmClangStdenv;
    buildTests = false; # Too many failures, most pass
    targetName = "openmp";
    targetDir = targetName;
    extraPatches = [ ./0000-fix-openmp.patch ];
    extraNativeBuildInputs = [ perl ];

    extraBuildInputs = [
      rocm-device-libs
      rocm-runtime
      elfutils
    ];

    extraCMakeFlags = [
      "-DCMAKE_MODULE_PATH=/build/source/llvm/cmake/modules" # For docs
      "-DCLANG_TOOL=${clang}/bin/clang"
      "-DCLANG_OFFLOAD_BUNDLER_TOOL=${clang-unwrapped}/bin/clang-offload-bundler"
      "-DOPENMP_LLVM_TOOLS_DIR=${llvm}/bin"
      "-DOPENMP_LLVM_LIT_EXECUTABLE=${lit}/bin/.lit-wrapped"
      "-DDEVICELIBS_ROOT=${rocm-device-libs.src}"
    ];

    extraPostPatch = ''
      # We can't build this target at the moment
      substituteInPlace libomptarget/DeviceRTL/CMakeLists.txt \
        --replace "gfx1010" ""
    '';

    checkTargets = [ "check-${targetName}" ];
    extraLicenses = [ lib.licenses.mit ];
  };

  # Runtimes
  pstl = callPackage ./llvm.nix rec {
    stdenv = rocmClangStdenv;
    buildDocs = false; # No documentation to build
    buildMan = false; # No man pages to build
    buildTests = false; # Too many errors
    targetName = "pstl";
    targetDir = "runtimes";
    targetRuntimes = [ targetName ];
    checkTargets = [ "check-${targetName}" ];
  };
}

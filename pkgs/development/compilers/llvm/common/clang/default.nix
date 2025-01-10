{ lib
, stdenv
, llvm_meta
, patches ? []
, src ? null
, monorepoSrc ? null
, runCommand
, substituteAll
, cmake
, ninja
, libxml2
, libllvm
, release_version
, version
, python3
, buildLlvmTools
, fixDarwinDylibNames
, enableManpages ? false
, clang-tools-extra_src ? null
}:

let
  pname = "clang";

  src' = if monorepoSrc != null then
    runCommand "${pname}-src-${version}" {} ''
      mkdir -p "$out"
      cp -r ${monorepoSrc}/cmake "$out"
      cp -r ${monorepoSrc}/${pname} "$out"
      cp -r ${monorepoSrc}/clang-tools-extra "$out"
    '' else src;

  self = stdenv.mkDerivation (finalAttrs: rec {
    inherit pname version patches;

    src = src';

    sourceRoot = if lib.versionOlder release_version "13" then null
      else "${src.name}/${pname}";

    nativeBuildInputs = [ cmake ]
      ++ (lib.optional (lib.versionAtLeast release_version "15") ninja)
      ++ [ python3 ]
      ++ lib.optional (lib.versionAtLeast version "18" && enableManpages) python3.pkgs.myst-parser
      ++ lib.optional enableManpages python3.pkgs.sphinx
      ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

    buildInputs = [ libxml2 libllvm ];

    cmakeFlags = (lib.optionals (lib.versionAtLeast release_version "15") [
      "-DCLANG_INSTALL_PACKAGE_DIR=${placeholder "dev"}/lib/cmake/clang"
    ]) ++ [
      "-DCLANGD_BUILD_XPC=OFF"
      "-DLLVM_ENABLE_RTTI=ON"
    ] ++ lib.optionals (lib.versionAtLeast release_version "17") [
      "-DLLVM_INCLUDE_TESTS=OFF"
    ] ++ lib.optionals enableManpages [
      "-DCLANG_INCLUDE_DOCS=ON"
      "-DLLVM_ENABLE_SPHINX=ON"
      "-DSPHINX_OUTPUT_MAN=ON"
      "-DSPHINX_OUTPUT_HTML=OFF"
      "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
    ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) ([
      "-DLLVM_TABLEGEN_EXE=${buildLlvmTools.llvm}/bin/llvm-tblgen"
      "-DCLANG_TABLEGEN=${buildLlvmTools.libclang.dev}/bin/clang-tblgen"
    ] ++ lib.optionals (lib.versionAtLeast release_version "15") [
      # Added in LLVM15:
      # `clang-tidy-confusable-chars-gen`: https://github.com/llvm/llvm-project/commit/c3574ef739fbfcc59d405985a3a4fa6f4619ecdb
      # `clang-pseudo-gen`: https://github.com/llvm/llvm-project/commit/cd2292ef824591cc34cc299910a3098545c840c7
      "-DCLANG_TIDY_CONFUSABLE_CHARS_GEN=${buildLlvmTools.libclang.dev}/bin/clang-tidy-confusable-chars-gen"
      "-DCLANG_PSEUDO_GEN=${buildLlvmTools.libclang.dev}/bin/clang-pseudo-gen"
    ]) ++ lib.optional (stdenv.targetPlatform.useLLVM or false) "-DCLANG_DEFAULT_CXX_STDLIB=ON";

    postPatch = ''
      # Make sure clang passes the correct location of libLTO to ld64
      substituteInPlace lib/Driver/ToolChains/Darwin.cpp \
        --replace-fail 'StringRef P = llvm::sys::path::parent_path(D.Dir);' 'StringRef P = "${lib.getLib libllvm}";'
    '' + (if lib.versionOlder release_version "13" then ''
      sed -i -e 's/DriverArgs.hasArg(options::OPT_nostdlibinc)/true/' \
             -e 's/Args.hasArg(options::OPT_nostdlibinc)/true/' \
             lib/Driver/ToolChains/*.cpp
    '' else ''
      (cd tools && ln -s ../../clang-tools-extra extra)
    '') + lib.optionalString stdenv.hostPlatform.isMusl ''
      sed -i -e 's/lgcc_s/lgcc_eh/' lib/Driver/ToolChains/*.cpp
    '';

    outputs = [ "out" "lib" "dev" "python" ];

    postInstall = ''
      ln -sv $out/bin/clang $out/bin/cpp
    '' + (lib.optionalString (lib.versions.major release_version == "17") ''

      mkdir -p $lib/lib/clang
      mv $lib/lib/17 $lib/lib/clang/17
    '') + (lib.optionalString (lib.versionAtLeast release_version "19") ''
      mv $out/lib/clang $lib/lib/clang
    '') + ''

      # Move libclang to 'lib' output
      moveToOutput "lib/libclang.*" "$lib"
      moveToOutput "lib/libclang-cpp.*" "$lib"
    '' + (if lib.versionOlder release_version "15" then ''
      substituteInPlace $out/lib/cmake/clang/ClangTargets-release.cmake \
          --replace "\''${_IMPORT_PREFIX}/lib/libclang." "$lib/lib/libclang." \
          --replace "\''${_IMPORT_PREFIX}/lib/libclang-cpp." "$lib/lib/libclang-cpp."
    '' else ''
      substituteInPlace $dev/lib/cmake/clang/ClangTargets-release.cmake \
          --replace "\''${_IMPORT_PREFIX}/lib/libclang." "$lib/lib/libclang." \
          --replace "\''${_IMPORT_PREFIX}/lib/libclang-cpp." "$lib/lib/libclang-cpp."
    '') + ''

    '' + (if lib.versionOlder release_version "15" then ''
      mkdir -p $python/bin $python/share/{clang,scan-view}
    '' else ''
      mkdir -p $python/bin $python/share/clang/
    '') + ''
      mv $out/bin/{git-clang-format,scan-view} $python/bin
      if [ -e $out/bin/set-xcode-analyzer ]; then
        mv $out/bin/set-xcode-analyzer $python/bin
      fi
      mv $out/share/clang/*.py $python/share/clang
    '' + (lib.optionalString (lib.versionOlder release_version "15") ''
      mv $out/share/scan-view/*.py $python/share/scan-view
    '') + ''
      rm $out/bin/c-index-test
      patchShebangs $python/bin

      mkdir -p $dev/bin
    '' + (if lib.versionOlder release_version "15" then ''
      cp bin/clang-tblgen $dev/bin
    '' else ''
      cp bin/{clang-tblgen,clang-tidy-confusable-chars-gen,clang-pseudo-gen} $dev/bin
    '');

    passthru = {
      inherit libllvm;
      isClang = true;
      hardeningUnsupportedFlagsByTargetPlatform = targetPlatform:
        [ "fortify3" ]
        ++ lib.optional (
          (lib.versionOlder release_version "7")
          || !targetPlatform.isLinux
          || !targetPlatform.isx86_64
        ) "shadowstack"
        ++ lib.optional (
          (lib.versionOlder release_version "8")
          || !targetPlatform.isAarch64
          || !targetPlatform.isLinux
        ) "pacret"
        ++ lib.optional (
          (lib.versionOlder release_version "11")
          || (targetPlatform.isAarch64 && (lib.versionOlder release_version "18.1"))
          || (targetPlatform.isFreeBSD && (lib.versionOlder release_version "15"))
          || !(targetPlatform.isLinux || targetPlatform.isFreeBSD)
          || !(
            targetPlatform.isx86
            || targetPlatform.isPower64
            || targetPlatform.isS390x
            || targetPlatform.isAarch64
          )
        ) "stackclashprotection"
        ++ lib.optional (
          (lib.versionOlder release_version "15")
          || !(targetPlatform.isx86_64 || targetPlatform.isAarch64)
        ) "zerocallusedregs"
        ++ (finalAttrs.passthru.hardeningUnsupportedFlags or []);
    };

    meta = llvm_meta // {
      homepage = "https://clang.llvm.org/";
      description = "C language family frontend for LLVM";
      longDescription = ''
        The Clang project provides a language front-end and tooling
        infrastructure for languages in the C language family (C, C++, Objective
        C/C++, OpenCL, CUDA, and RenderScript) for the LLVM project.
        It aims to deliver amazingly fast compiles, extremely useful error and
        warning messages and to provide a platform for building great source
        level tools. The Clang Static Analyzer and clang-tidy are tools that
        automatically find bugs in your code, and are great examples of the sort
        of tools that can be built using the Clang frontend as a library to
        parse C/C++ code.
      '';
      mainProgram = "clang";
    };
  } // lib.optionalAttrs enableManpages ({
    pname = "clang-manpages";

    installPhase = ''
      mkdir -p $out/share/man/man1
      # Manually install clang manpage
      cp docs/man/*.1 $out/share/man/man1/
    '';

    outputs = [ "out" ];

    doCheck = false;

    meta = llvm_meta // {
      description = "man page for Clang ${version}";
    };
  } // (if lib.versionOlder release_version "15" then {
    buildPhase = ''
      make docs-clang-man
    '';
  } else {
    ninjaFlags = [ "docs-clang-man" ];
  })) // (lib.optionalAttrs (clang-tools-extra_src != null) { inherit clang-tools-extra_src; })
    // (lib.optionalAttrs (lib.versionOlder release_version "13") {
      unpackPhase = ''
        unpackFile $src
        mv clang-* clang
        sourceRoot=$PWD/clang
        unpackFile ${clang-tools-extra_src}
        mv clang-tools-extra-* $sourceRoot/tools/extra
        substituteInPlace $sourceRoot/tools/extra/clangd/quality/CompletionModel.cmake \
          --replace ' ''${CMAKE_SOURCE_DIR}/../clang-tools-extra' ' ''${CMAKE_SOURCE_DIR}/tools/extra'
      '';
    })
  // (lib.optionalAttrs (lib.versionAtLeast release_version "15") {
    env = lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform && !stdenv.hostPlatform.useLLVM) {
      # The following warning is triggered with (at least) gcc >=
      # 12, but appears to occur only for cross compiles.
      NIX_CFLAGS_COMPILE = "-Wno-maybe-uninitialized";
    };
  }));
in self

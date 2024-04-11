{ lib, stdenv, llvm_meta
, monorepoSrc, runCommand
, substituteAll, cmake, ninja, libxml2, libllvm, version, python3
, buildLlvmTools
, fixDarwinDylibNames
, enableManpages ? false
}:

let
  self = stdenv.mkDerivation (finalAttrs: rec {
    pname = "clang";
    inherit version;

    src = runCommand "${pname}-src-${version}" {} ''
      mkdir -p "$out"
      cp -r ${monorepoSrc}/cmake "$out"
      cp -r ${monorepoSrc}/${pname} "$out"
      cp -r ${monorepoSrc}/clang-tools-extra "$out"
    '';

    sourceRoot = "${src.name}/${pname}";

    nativeBuildInputs = [ cmake ninja python3 ]
      ++ lib.optional (lib.versionAtLeast version "18" && enableManpages) python3.pkgs.myst-parser
      ++ lib.optional enableManpages python3.pkgs.sphinx
      ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

    buildInputs = [ libxml2 libllvm ];

    cmakeFlags = [
      "-DCLANG_INSTALL_PACKAGE_DIR=${placeholder "dev"}/lib/cmake/clang"
      "-DCLANGD_BUILD_XPC=OFF"
      "-DLLVM_ENABLE_RTTI=ON"
      "-DLLVM_INCLUDE_TESTS=OFF"
    ] ++ lib.optionals enableManpages [
      "-DCLANG_INCLUDE_DOCS=ON"
      "-DLLVM_ENABLE_SPHINX=ON"
      "-DSPHINX_OUTPUT_MAN=ON"
      "-DSPHINX_OUTPUT_HTML=OFF"
      "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
    ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "-DLLVM_TABLEGEN_EXE=${buildLlvmTools.llvm}/bin/llvm-tblgen"
      "-DCLANG_TABLEGEN=${buildLlvmTools.libclang.dev}/bin/clang-tblgen"
      # Added in LLVM15:
      # `clang-tidy-confusable-chars-gen`: https://github.com/llvm/llvm-project/commit/c3574ef739fbfcc59d405985a3a4fa6f4619ecdb
      # `clang-pseudo-gen`: https://github.com/llvm/llvm-project/commit/cd2292ef824591cc34cc299910a3098545c840c7
      "-DCLANG_TIDY_CONFUSABLE_CHARS_GEN=${buildLlvmTools.libclang.dev}/bin/clang-tidy-confusable-chars-gen"
      "-DCLANG_PSEUDO_GEN=${buildLlvmTools.libclang.dev}/bin/clang-pseudo-gen"
    ];

    patches = [
      ./purity.patch
      # https://reviews.llvm.org/D51899
      ./gnu-install-dirs.patch
      ../../common/clang/add-nostdlibinc-flag.patch
      (substituteAll {
        src = ../../common/clang/clang-at-least-16-LLVMgold-path.patch;
       libllvmLibdir = "${libllvm.lib}/lib";
      })
    ];

    postPatch = ''
      (cd tools && ln -s ../../clang-tools-extra extra)
    '' + lib.optionalString stdenv.hostPlatform.isMusl ''
      sed -i -e 's/lgcc_s/lgcc_eh/' lib/Driver/ToolChains/*.cpp
    '';

    outputs = [ "out" "lib" "dev" "python" ];

    postInstall = ''
      ln -sv $out/bin/clang $out/bin/cpp

      # Move libclang to 'lib' output
      moveToOutput "lib/libclang.*" "$lib"
      moveToOutput "lib/libclang-cpp.*" "$lib"
      substituteInPlace $dev/lib/cmake/clang/ClangTargets-release.cmake \
          --replace "\''${_IMPORT_PREFIX}/lib/libclang." "$lib/lib/libclang." \
          --replace "\''${_IMPORT_PREFIX}/lib/libclang-cpp." "$lib/lib/libclang-cpp."

      mkdir -p $python/bin $python/share/clang/
      mv $out/bin/{git-clang-format,scan-view} $python/bin
      if [ -e $out/bin/set-xcode-analyzer ]; then
        mv $out/bin/set-xcode-analyzer $python/bin
      fi
      mv $out/share/clang/*.py $python/share/clang
      rm $out/bin/c-index-test
      patchShebangs $python/bin

      mkdir -p $dev/bin
      cp bin/{clang-tblgen,clang-tidy-confusable-chars-gen,clang-pseudo-gen} $dev/bin
    '';

    passthru = {
      inherit libllvm;
      isClang = true;
      hardeningUnsupportedFlags = [
        "fortify3"
      ];
      hardeningUnsupportedFlagsByTargetPlatform = targetPlatform:
        lib.optional (!(targetPlatform.isx86_64 || targetPlatform.isAarch64)) "zerocallusedregs"
        ++ (finalAttrs.passthru.hardeningUnsupportedFlags or []);
    };

    meta = llvm_meta // {
      homepage = "https://clang.llvm.org/";
      description = "A C language family frontend for LLVM";
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
  } // lib.optionalAttrs enableManpages {
    pname = "clang-manpages";

    ninjaFlags = [ "docs-clang-man" ];

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
  });
in self

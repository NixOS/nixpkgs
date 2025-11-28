{
  lib,
  stdenv,
  llvm_meta,
  src ? null,
  monorepoSrc ? null,
  runCommand,
  cmake,
  ninja,
  libxml2,
  libllvm,
  release_version,
  version,
  python3,
  buildLlvmPackages,
  fixDarwinDylibNames,
  enableManpages ? false,
  enableClangToolsExtra ? true,
  devExtraCmakeFlags ? [ ],
  replaceVars,
  getVersionFile,
  fetchpatch,
  # for tests
  libclang,
}:
stdenv.mkDerivation (
  finalAttrs:
  {
    pname = "clang";
    inherit version;

    src =
      if monorepoSrc != null then
        runCommand "clang-src-${version}" { inherit (monorepoSrc) passthru; } ''
          mkdir -p "$out"
          cp -r ${monorepoSrc}/cmake "$out"
          cp -r ${monorepoSrc}/clang "$out"
          ${lib.optionalString enableClangToolsExtra "cp -r ${monorepoSrc}/clang-tools-extra \"$out\""}
        ''
      else
        src;

    sourceRoot = "${finalAttrs.src.name}/clang";

    patches = [
      (getVersionFile "clang/purity.patch")
      # Remove extraneous ".a" suffix from baremetal clang_rt.builtins when compiling for baremetal.
      # https://reviews.llvm.org/D51899
      (getVersionFile "clang/gnu-install-dirs.patch")
    ]
    ++ lib.optionals (lib.versionOlder release_version "20") [
      # https://github.com/llvm/llvm-project/pull/116476
      # prevent clang ignoring warnings / errors for unsuppored
      # options when building & linking a source file with trailing
      # libraries. eg: `clang -munsupported hello.c -lc`
      ./clang-unsupported-option.patch
    ]
    # Pass the correct path to libllvm
    ++ [
      (replaceVars ./clang-at-least-16-LLVMgold-path.patch {
        libllvmLibdir = "${libllvm.lib}/lib";
      })
    ]
    # Fixes a bunch of lambda-related crashes
    # https://github.com/llvm/llvm-project/pull/93206
    ++ lib.optional (lib.versions.major release_version == "18") (fetchpatch {
      name = "tweak-tryCaptureVariable-for-unevaluated-lambdas.patch";
      url = "https://github.com/llvm/llvm-project/commit/3d361b225fe89ce1d8c93639f27d689082bd8dad.patch";
      # TreeTransform.h is not affected in LLVM 18.
      excludes = [
        "docs/ReleaseNotes.rst"
        "lib/Sema/TreeTransform.h"
      ];
      stripLen = 1;
      hash = "sha256-1NKej08R9SPlbDY/5b0OKUsHjX07i9brR84yXiPwi7E=";
    });

    nativeBuildInputs = [
      cmake
      python3
      ninja
    ]
    ++ lib.optionals enableManpages [
      python3.pkgs.myst-parser
      python3.pkgs.sphinx
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

    buildInputs = [
      libxml2
      libllvm
    ];

    cmakeFlags = [
      (lib.cmakeFeature "CLANG_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/clang")
      (lib.cmakeBool "CLANGD_BUILD_XPC" false)
      (lib.cmakeBool "LLVM_ENABLE_RTTI" true)
      (lib.cmakeBool "LLVM_INCLUDE_TESTS" false)
      (lib.cmakeFeature "LLVM_TABLEGEN_EXE" "${buildLlvmPackages.tblgen}/bin/llvm-tblgen")
      (lib.cmakeFeature "CLANG_TABLEGEN" "${buildLlvmPackages.tblgen}/bin/clang-tblgen")
      (lib.cmakeFeature "CLANG_TIDY_CONFUSABLE_CHARS_GEN" "${buildLlvmPackages.tblgen}/bin/clang-tidy-confusable-chars-gen")
    ]
    ++ lib.optional (lib.versionAtLeast release_version "20") (
      lib.cmakeFeature "LLVM_DIR" "${libllvm.dev}/lib/cmake/llvm"
    )
    ++ lib.optionals (lib.versionAtLeast release_version "21") [
      (lib.cmakeFeature "CLANG_RESOURCE_DIR" "${placeholder "lib"}/lib/clang/${lib.versions.major release_version}")
    ]
    ++ lib.optionals enableManpages [
      (lib.cmakeBool "CLANG_INCLUDE_DOCS" true)
      (lib.cmakeBool "LLVM_ENABLE_SPHINX" true)
      (lib.cmakeBool "SPHINX_OUTPUT_MAN" true)
      (lib.cmakeBool "SPHINX_OUTPUT_HTML" false)
      (lib.cmakeBool "SPHINX_WARNINGS_AS_ERRORS" false)
    ]
    ++ lib.optionals (lib.versionOlder release_version "20") [
      # clang-pseudo removed in LLVM20: https://github.com/llvm/llvm-project/commit/ed8f78827895050442f544edef2933a60d4a7935
      (lib.cmakeFeature "CLANG_PSEUDO_GEN" "${buildLlvmPackages.tblgen}/bin/clang-pseudo-gen")
    ]
    ++ devExtraCmakeFlags;

    postPatch = ''
      # Make sure clang passes the correct location of libLTO to ld64
      substituteInPlace lib/Driver/ToolChains/Darwin.cpp \
        --replace-fail 'StringRef P = llvm::sys::path::parent_path(D.Dir);' 'StringRef P = "${lib.getLib libllvm}";'
      (cd tools && ln -s ../../clang-tools-extra extra)
    ''
    + lib.optionalString stdenv.hostPlatform.isMusl ''
      sed -i -e 's/lgcc_s/lgcc_eh/' lib/Driver/ToolChains/*.cpp
    '';

    outputs = [
      "out"
      "lib"
      "dev"
      "python"
    ];

    separateDebugInfo = stdenv.buildPlatform.is64bit; # OOMs on 32 bit

    postInstall = ''
      ln -sv $out/bin/clang $out/bin/cpp
    ''
    + (lib.optionalString
      ((lib.versionAtLeast release_version "19") && !(lib.versionAtLeast release_version "21"))
      ''
        mv $out/lib/clang $lib/lib/clang
      ''
    )
    + ''

      # Move libclang to 'lib' output
      moveToOutput "lib/libclang.*" "$lib"
      moveToOutput "lib/libclang-cpp.*" "$lib"
      mkdir -p $python/bin $python/share/clang/
    ''
    + ''
      mv $out/bin/{git-clang-format,scan-view} $python/bin
      if [ -e $out/bin/set-xcode-analyzer ]; then
        mv $out/bin/set-xcode-analyzer $python/bin
      fi
      mv $out/share/clang/*.py $python/share/clang
      rm $out/bin/c-index-test
      patchShebangs $python/bin

      mkdir -p $dev/bin
      cp bin/clang-tblgen $dev/bin
    ''
    + lib.optionalString enableClangToolsExtra ''
      cp bin/clang-tidy-confusable-chars-gen $dev/bin
    ''
    + lib.optionalString (enableClangToolsExtra && lib.versionOlder release_version "20") ''
      cp bin/clang-pseudo-gen $dev/bin
    '';

    env =
      lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform && !stdenv.hostPlatform.useLLVM)
        {
          # The following warning is triggered with (at least) gcc >=
          # 12, but appears to occur only for cross compiles.
          NIX_CFLAGS_COMPILE = "-Wno-maybe-uninitialized";
        };

    passthru = {
      inherit libllvm;
      isClang = true;
      hardeningUnsupportedFlagsByTargetPlatform =
        targetPlatform:
        [ "fortify3" ]
        ++ lib.optional (!targetPlatform.isLinux || !targetPlatform.isx86_64) "shadowstack"
        ++ lib.optional (!targetPlatform.isAarch64 || !targetPlatform.isLinux) "pacret"
        ++ lib.optional (
          !(targetPlatform.isLinux || targetPlatform.isFreeBSD)
          || !(
            targetPlatform.isx86
            || targetPlatform.isPower64
            || targetPlatform.isS390x
            || targetPlatform.isAarch64
          )
        ) "stackclashprotection"
        ++ lib.optional (!(targetPlatform.isx86_64 || targetPlatform.isAarch64)) "zerocallusedregs"
        ++ (finalAttrs.passthru.hardeningUnsupportedFlags or [ ]);
      tests.withoutOptionalFeatures = libclang.override {
        enableClangToolsExtra = false;
      };
    };

    requiredSystemFeatures = [ "big-parallel" ];
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
      badPlatforms = (llvm_meta.badPlatforms or [ ]) ++ [
        "powerpc-linux"
      ];
    };
  }
  // lib.optionalAttrs enableManpages {
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
  }
)

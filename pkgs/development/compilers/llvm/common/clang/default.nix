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
  buildLlvmTools,
  fixDarwinDylibNames,
  enableManpages ? false,
  devExtraCmakeFlags ? [ ],
  replaceVars,
  getVersionFile,
  fetchpatch,
}:
stdenv.mkDerivation (
  finalAttrs:
  {
    pname = "clang";
    inherit version;

    src =
      if monorepoSrc != null then
        runCommand "clang-src-${version}" { inherit (monorepoSrc) passthru; } (
          ''
            mkdir -p "$out"
          ''
          + lib.optionalString (lib.versionAtLeast release_version "14") ''
            cp -r ${monorepoSrc}/cmake "$out"
          ''
          + ''
            cp -r ${monorepoSrc}/clang "$out"
            cp -r ${monorepoSrc}/clang-tools-extra "$out"
          ''
        )
      else
        src;

    sourceRoot = "${finalAttrs.src.name}/clang";

    patches =
      [
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
      ++
        lib.optional (lib.versions.major release_version == "13")
          # Revert of https://reviews.llvm.org/D100879
          # The malloc alignment assumption is incorrect for jemalloc and causes
          # mis-compilation in firefox.
          # See: https://bugzilla.mozilla.org/show_bug.cgi?id=1741454
          (getVersionFile "clang/revert-malloc-alignment-assumption.patch")
      ++ lib.optional (lib.versionOlder release_version "17") (
        if lib.versionAtLeast release_version "14" then
          fetchpatch {
            name = "ignore-nostd-link.patch";
            url = "https://github.com/llvm/llvm-project/commit/5b77e752dcd073846b89559d6c0e1a7699e58615.patch";
            relative = "clang";
            hash = "sha256-qzSAmoGY+7POkDhcGgQRPaNQ3+7PIcIc9cZuiE/eLkc=";
          }
        else
          ./ignore-nostd-link-13.diff
      )
      # Pass the correct path to libllvm
      ++ [
        (replaceVars
          (
            if (lib.versionOlder release_version "16") then
              ./clang-11-15-LLVMgold-path.patch
            else
              ./clang-at-least-16-LLVMgold-path.patch
          )
          {
            libllvmLibdir = "${libllvm.lib}/lib";
          }
        )
      ]
      # Backport version logic from Clang 16. This is needed by the following patch.
      ++ lib.optional (lib.versions.major release_version == "15") (fetchpatch {
        name = "clang-darwin-Use-consistent-version-define-stringifying-logic.patch";
        url = "https://github.com/llvm/llvm-project/commit/60a33ded751c86fff9ac1c4bdd2b341fbe4b0649.patch?full_index=1";
        includes = [ "lib/Basic/Targets/OSTargets.cpp" ];
        stripLen = 1;
        hash = "sha256-YVTSg5eZLz3po2AUczPNXCK26JA3CuTh6Iqp7hAAKIs=";
      })
      # Backport `__ENVIRONMENT_OS_VERSION_MIN_REQUIRED__` support from Clang 17.
      # This is needed by newer SDKs (14+).
      ++
        lib.optional
          (
            lib.versionAtLeast (lib.versions.major release_version) "15"
            && lib.versionOlder (lib.versions.major release_version) "17"
          )
          (fetchpatch {
            name = "clang-darwin-An-OS-version-preprocessor-define.patch";
            url = "https://github.com/llvm/llvm-project/commit/c8e2dd8c6f490b68e41fe663b44535a8a21dfeab.patch?full_index=1";
            includes = [ "lib/Basic/Targets/OSTargets.cpp" ];
            stripLen = 1;
            hash = "sha256-Vs32kql7N6qtLqc12FtZHURcbenA7+N3E/nRRX3jdig=";
          })
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
      })
      ++
        lib.optional (stdenv.isAarch64 && lib.versions.major release_version == "17")
          # Fixes llvm17 tblgen builds on aarch64.
          # https://github.com/llvm/llvm-project/issues/106521#issuecomment-2337175680
          (getVersionFile "clang/aarch64-tblgen.patch");

    nativeBuildInputs =
      [
        cmake
        python3
      ]
      ++ (lib.optional (lib.versionAtLeast release_version "15") ninja)
      ++ lib.optional (lib.versionAtLeast version "18" && enableManpages) python3.pkgs.myst-parser
      ++ lib.optional enableManpages python3.pkgs.sphinx
      ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

    buildInputs = [
      libxml2
      libllvm
    ];

    cmakeFlags =
      (lib.optionals (lib.versionAtLeast release_version "15") [
        (lib.cmakeFeature "CLANG_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/clang")
      ])
      ++ [
        (lib.cmakeBool "CLANGD_BUILD_XPC" false)
        (lib.cmakeBool "LLVM_ENABLE_RTTI" true)
        (lib.cmakeFeature "LLVM_TABLEGEN_EXE" "${buildLlvmTools.tblgen}/bin/llvm-tblgen")
        (lib.cmakeFeature "CLANG_TABLEGEN" "${buildLlvmTools.tblgen}/bin/clang-tblgen")
      ]
      ++ lib.optionals (lib.versionAtLeast release_version "21") [
        (lib.cmakeFeature "CLANG_RESOURCE_DIR" "${placeholder "lib"}/lib/clang/${lib.versions.major release_version}")
      ]
      ++ lib.optionals (lib.versionAtLeast release_version "17") [
        (lib.cmakeBool "LLVM_INCLUDE_TESTS" false)
      ]
      ++ lib.optionals enableManpages [
        (lib.cmakeBool "CLANG_INCLUDE_DOCS" true)
        (lib.cmakeBool "LLVM_ENABLE_SPHINX" true)
        (lib.cmakeBool "SPHINX_OUTPUT_MAN" true)
        (lib.cmakeBool "SPHINX_OUTPUT_HTML" false)
        (lib.cmakeBool "SPHINX_WARNINGS_AS_ERRORS" false)
      ]
      ++ lib.optionals (lib.versionAtLeast release_version "15") [
        # Added in LLVM15:
        # `clang-tidy-confusable-chars-gen`: https://github.com/llvm/llvm-project/commit/c3574ef739fbfcc59d405985a3a4fa6f4619ecdb
        # `clang-pseudo-gen`: https://github.com/llvm/llvm-project/commit/cd2292ef824591cc34cc299910a3098545c840c7
        (lib.cmakeFeature "CLANG_TIDY_CONFUSABLE_CHARS_GEN" "${buildLlvmTools.tblgen}/bin/clang-tidy-confusable-chars-gen")
      ]
      ++ lib.optionals (lib.versionOlder release_version "20") [
        # clang-pseudo removed in LLVM20: https://github.com/llvm/llvm-project/commit/ed8f78827895050442f544edef2933a60d4a7935
        (lib.cmakeFeature "CLANG_PSEUDO_GEN" "${buildLlvmTools.tblgen}/bin/clang-pseudo-gen")
      ]
      ++ lib.optional (lib.versionAtLeast release_version "20") (
        lib.cmakeFeature "LLVM_DIR" "${libllvm.dev}/lib/cmake/llvm"
      )
      ++ devExtraCmakeFlags;

    postPatch =
      ''
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

    postInstall =
      ''
        ln -sv $out/bin/clang $out/bin/cpp
      ''
      + (lib.optionalString (lib.versions.major release_version == "17") ''
        mkdir -p $lib/lib/clang
        mv $lib/lib/17 $lib/lib/clang/17
      '')
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
      ''
      + (
        if lib.versionOlder release_version "15" then
          ''
            mkdir -p $python/bin $python/share/{clang,scan-view}
          ''
        else
          ''
            mkdir -p $python/bin $python/share/clang/
          ''
      )
      + ''
        mv $out/bin/{git-clang-format,scan-view} $python/bin
        if [ -e $out/bin/set-xcode-analyzer ]; then
          mv $out/bin/set-xcode-analyzer $python/bin
        fi
        mv $out/share/clang/*.py $python/share/clang
      ''
      + (lib.optionalString (lib.versionOlder release_version "15") ''
        mv $out/share/scan-view/*.py $python/share/scan-view
      '')
      + ''
        rm $out/bin/c-index-test
        patchShebangs $python/bin

        mkdir -p $dev/bin
      ''
      + (
        if lib.versionOlder release_version "15" then
          ''
            cp bin/clang-tblgen $dev/bin
          ''
        else if lib.versionOlder release_version "20" then
          ''
            cp bin/{clang-tblgen,clang-tidy-confusable-chars-gen,clang-pseudo-gen} $dev/bin
          ''
        else
          ''
            cp bin/{clang-tblgen,clang-tidy-confusable-chars-gen} $dev/bin
          ''
      );

    env =
      lib.optionalAttrs
        (
          stdenv.buildPlatform != stdenv.hostPlatform
          && !stdenv.hostPlatform.useLLVM
          && lib.versionAtLeast release_version "15"
        )
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
        ++ lib.optional (
          (lib.versionOlder release_version "7") || !targetPlatform.isLinux || !targetPlatform.isx86_64
        ) "shadowstack"
        ++ lib.optional (
          (lib.versionOlder release_version "8") || !targetPlatform.isAarch64 || !targetPlatform.isLinux
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
          (lib.versionOlder release_version "15") || !(targetPlatform.isx86_64 || targetPlatform.isAarch64)
        ) "zerocallusedregs"
        ++ lib.optional (lib.versionOlder release_version "15") "strictflexarrays1"
        ++ lib.optional (lib.versionOlder release_version "16") "strictflexarrays3"
        ++ (finalAttrs.passthru.hardeningUnsupportedFlags or [ ]);
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
    };
  }
  // lib.optionalAttrs enableManpages (
    {
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
    }
    // (
      if lib.versionOlder release_version "15" then
        {
          buildPhase = ''
            make docs-clang-man
          '';
        }
      else
        {
          ninjaFlags = [ "docs-clang-man" ];
        }
    )
  )
)

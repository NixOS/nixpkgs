{
  lib,
  stdenv,
  llvm_meta,
  release_version,
  cmake,
  zlib,
  ncurses,
  swig,
  which,
  libedit,
  libxml2,
  libllvm,
  libclang,
  python3,
  version,
  darwin,
  lit,
  makeWrapper,
  lua5_3,
  ninja,
  runCommand,
  src ? null,
  monorepoSrc ? null,
  enableManpages ? false,
  devExtraCmakeFlags ? [ ],
  getVersionFile,
  fetchpatch,
  fetchpatch2,
  replaceVars,
  ...
}:

let
  vscodeExt = {
    name = if lib.versionAtLeast release_version "18" then "lldb-dap" else "lldb-vscode";
    version = if lib.versionAtLeast release_version "18" then "0.2.0" else "0.1.0";
  };
in

stdenv.mkDerivation (
  finalAttrs:
  {
    passthru.monorepoSrc = monorepoSrc;
    pname = "lldb";
    inherit version;

    src =
      if monorepoSrc != null then
        runCommand "lldb-src-${version}" { inherit (monorepoSrc) passthru; } (
          ''
            mkdir -p "$out"
          ''
          + lib.optionalString (lib.versionAtLeast release_version "14") ''
            cp -r ${monorepoSrc}/cmake "$out"
          ''
          + ''
            cp -r ${monorepoSrc}/lldb "$out"
          ''
          + lib.optionalString (lib.versionAtLeast release_version "19" && enableManpages) ''
            mkdir -p "$out/llvm"
            cp -r ${monorepoSrc}/llvm/docs "$out/llvm/docs"
          ''
        )
      else
        src;

    # There is no `lib` output because some of the files in `$out/lib` depend on files in `$out/bin`.
    # For example, `$out/lib/python3.12/site-packages/lldb/lldb-argdumper` is a symlink to `$out/bin/lldb-argdumper`.
    # Also, LLDB expects to find the path to `bin` relative to `lib` on Darwin.
    outputs = [
      "out"
      "dev"
    ];

    sourceRoot = lib.optional (lib.versionAtLeast release_version "13") "${finalAttrs.src.name}/lldb";

    patches =
      let
        resourceDirPatch =
          (replaceVars (getVersionFile "lldb/resource-dir.patch") {
            clangLibDir = "${lib.getLib libclang}/lib";
          }).overrideAttrs
            (_: _: { name = "resource-dir.patch"; });
      in
      lib.optionals (lib.versionOlder release_version "15") [
        # Fixes for SWIG 4
        (fetchpatch2 {
          url = "https://github.com/llvm/llvm-project/commit/81fc5f7909a4ef5a8d4b5da2a10f77f7cb01ba63.patch?full_index=1";
          stripLen = 1;
          hash = "sha256-Znw+C0uEw7lGETQLKPBZV/Ymo2UigZS+Hv/j1mUo7p0=";
        })
        (fetchpatch2 {
          url = "https://github.com/llvm/llvm-project/commit/f0a25fe0b746f56295d5c02116ba28d2f965c175.patch?full_index=1";
          stripLen = 1;
          hash = "sha256-QzVeZzmc99xIMiO7n//b+RNAvmxghISKQD93U2zOgFI=";
        })
      ]
      ++ lib.optionals (lib.versionOlder release_version "16") [
        # Fixes for SWIG 4
        (fetchpatch2 {
          url = "https://github.com/llvm/llvm-project/commit/ba35c27ec9aa9807f5b4be2a0c33ca9b045accc7.patch?full_index=1";
          stripLen = 1;
          hash = "sha256-LXl+WbpmWZww5xMDrle3BM2Tw56v8k9LO1f1Z1/wDTs=";
        })
        (fetchpatch2 {
          url = "https://github.com/llvm/llvm-project/commit/9ec115978ea2bdfc60800cd3c21264341cdc8b0a.patch?full_index=1";
          stripLen = 1;
          hash = "sha256-u0zSejEjfrH3ZoMFm1j+NVv2t5AP9cE5yhsrdTS1dG4=";
        })

        # FIXME: do we need this after 15?
        (getVersionFile "lldb/procfs.patch")
      ]
      ++ lib.optional (lib.versionOlder release_version "18") (fetchpatch {
        name = "libcxx-19-char_traits.patch";
        url = "https://github.com/llvm/llvm-project/commit/68744ffbdd7daac41da274eef9ac0d191e11c16d.patch";
        stripLen = 1;
        hash = "sha256-QCGhsL/mi7610ZNb5SqxjRGjwJeK2rwtsFVGeG3PUGc=";
      })
      ++ lib.optionals (lib.versionOlder release_version "17") [
        resourceDirPatch
        (fetchpatch {
          name = "add-cstdio.patch";
          url = "https://github.com/llvm/llvm-project/commit/73e15b5edb4fa4a77e68c299a6e3b21e610d351f.patch";
          stripLen = 1;
          hash = "sha256-eFcvxZaAuBsY/bda1h9212QevrXyvCHw8Cr9ngetDr0=";
        })
      ]
      ++ lib.optional (lib.versionOlder release_version "14") (
        getVersionFile "lldb/gnu-install-dirs.patch"
      )
      ++ lib.optional (lib.versionAtLeast release_version "14") ./gnu-install-dirs.patch;

    nativeBuildInputs = [
      cmake
      python3
      which
      swig
      lit
      makeWrapper
      lua5_3
    ]
    ++ lib.optionals enableManpages [
      python3.pkgs.sphinx
    ]
    ++ lib.optionals (lib.versionOlder release_version "18" && enableManpages) [
      python3.pkgs.recommonmark
    ]
    ++ lib.optionals (lib.versionAtLeast release_version "18" && enableManpages) [
      python3.pkgs.myst-parser
    ]
    ++ lib.optionals (lib.versionAtLeast release_version "14") [
      ninja
    ];

    buildInputs = [
      ncurses
      zlib
      libedit
      libxml2
      libllvm
    ]
    ++ lib.optionals (lib.versionAtLeast release_version "16") [
      # Starting with LLVM 16, the resource dir patch is no longer enough to get
      # libclang into the rpath of the lldb executables. By putting it into
      # buildInputs cc-wrapper will set up rpath correctly for us.
      (lib.getLib libclang)
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.bootstrap_cmds
    ];

    hardeningDisable = [ "format" ];

    cmakeFlags = [
      (lib.cmakeBool "LLDB_INCLUDE_TESTS" finalAttrs.finalPackage.doCheck)
      (lib.cmakeBool "LLVM_ENABLE_RTTI" false)
      (lib.cmakeFeature "Clang_DIR" "${lib.getDev libclang}/lib/cmake")
      (lib.cmakeFeature "LLVM_EXTERNAL_LIT" "${lit}/bin/lit")
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (lib.cmakeBool "LLDB_USE_SYSTEM_DEBUGSERVER" true)
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      (lib.cmakeFeature "LLDB_CODESIGN_IDENTITY" "") # codesigning makes nondeterministic
    ]
    ++ lib.optionals (lib.versionAtLeast release_version "17") [
      (lib.cmakeFeature "CLANG_RESOURCE_DIR" "../../../../${lib.getLib libclang}")
    ]
    ++ lib.optionals enableManpages (
      [
        (lib.cmakeBool "LLVM_ENABLE_SPHINX" true)
        (lib.cmakeBool "SPHINX_OUTPUT_MAN" true)
        (lib.cmakeBool "SPHINX_OUTPUT_HTML" false)
      ]
      ++ lib.optionals (lib.versionAtLeast release_version "15") [
        # docs reference `automodapi` but it's not added to the extensions list when
        # only building the manpages:
        # https://github.com/llvm/llvm-project/blob/af6ec9200b09039573d85e349496c4f5b17c3d7f/lldb/docs/conf.py#L54
        #
        # so, we just ignore the resulting errors
        (lib.cmakeBool "SPHINX_WARNINGS_AS_ERRORS" false)
      ]
    )
    ++ lib.optionals finalAttrs.finalPackage.doCheck [
      (lib.cmakeFeature "LLDB_TEST_C_COMPILER" "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc")
      (lib.cmakeFeature "-DLLDB_TEST_CXX_COMPILER" "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++")
    ]
    ++ devExtraCmakeFlags;

    doCheck = false;
    doInstallCheck = lib.versionOlder release_version "15";

    # TODO: cleanup with mass-rebuild
    installCheckPhase = ''
      if [ ! -e ''${!outputLib}/${python3.sitePackages}/lldb/_lldb*.so ] ; then
          echo "ERROR: python files not installed where expected!";
          return 1;
      fi
    '' # Something lua is built on older versions but this file doesn't exist.
    + lib.optionalString (lib.versionAtLeast release_version "14") ''
      if [ ! -e "''${!outputLib}/lib/lua/${lua5_3.luaversion}/lldb.so" ] ; then
          echo "ERROR: lua files not installed where expected!";
          return 1;
      fi
    '';

    postInstall = ''
      wrapProgram $out/bin/lldb --prefix PYTHONPATH : ''${!outputLib}/${python3.sitePackages}/

      # Editor support
      # vscode:
      install -D ../tools/${vscodeExt.name}/package.json $out/share/vscode/extensions/llvm-org.${vscodeExt.name}-${vscodeExt.version}/package.json
      mkdir -p $out/share/vscode/extensions/llvm-org.${vscodeExt.name}-${vscodeExt.version}/bin
      ln -s $out/bin/*${
        if lib.versionAtLeast release_version "18" then vscodeExt.name else "-vscode"
      } $out/share/vscode/extensions/llvm-org.${vscodeExt.name}-${vscodeExt.version}/bin
    '';

    passthru.vscodeExtName = vscodeExt.name;
    passthru.vscodeExtPublisher = "llvm";
    passthru.vscodeExtUniqueId = "llvm-org.${vscodeExt.name}-${vscodeExt.version}";

    meta = llvm_meta // {
      homepage = "https://lldb.llvm.org/";
      description = "Next-generation high-performance debugger";
      longDescription = ''
        LLDB is a next generation, high-performance debugger. It is built as a set
        of reusable components which highly leverage existing libraries in the
        larger LLVM Project, such as the Clang expression parser and LLVM
        disassembler.
      '';
      broken = lib.versionOlder release_version "14";
      mainProgram = "lldb";
    };
  }
  // lib.optionalAttrs enableManpages {
    pname = "lldb-manpages";

    buildPhase = lib.optionalString (lib.versionOlder release_version "15") ''
      make ${if (lib.versionOlder release_version "12") then "docs-man" else "docs-lldb-man"}
    '';

    ninjaFlags = lib.optionals (lib.versionAtLeast release_version "15") [ "docs-lldb-man" ];

    propagatedBuildInputs = [ ];

    # manually install lldb man page
    installPhase = ''
      mkdir -p $out/share/man/man1
      install docs/man/lldb.1 -t $out/share/man/man1/
    '';

    postPatch = null;
    postInstall = null;

    outputs = [ "out" ];

    doCheck = false;

    meta = llvm_meta // {
      description = "man pages for LLDB ${version}";
    };
  }
)

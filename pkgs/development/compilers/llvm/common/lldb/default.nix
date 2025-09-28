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
}:

let
  vscodeExt = {
    name = "lldb-dap";
    version = "0.2.0";
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
            cp -r ${monorepoSrc}/cmake "$out"
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

    sourceRoot = "${finalAttrs.src.name}/lldb";

    patches = [ ./gnu-install-dirs.patch ];

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
      python3.pkgs.myst-parser
    ]
    # TODO: Clean up on `staging`.
    ++ [
      ninja
    ];

    buildInputs = [
      ncurses
      zlib
      libedit
      libxml2
      libllvm
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
    # TODO: Clean up on `staging`.
    ++ [
      (lib.cmakeFeature "CLANG_RESOURCE_DIR" "../../../../${lib.getLib libclang}")
    ]
    ++ lib.optionals enableManpages [
      (lib.cmakeBool "LLVM_ENABLE_SPHINX" true)
      (lib.cmakeBool "SPHINX_OUTPUT_MAN" true)
      (lib.cmakeBool "SPHINX_OUTPUT_HTML" false)
      # docs reference `automodapi` but it's not added to the extensions list when
      # only building the manpages:
      # https://github.com/llvm/llvm-project/blob/af6ec9200b09039573d85e349496c4f5b17c3d7f/lldb/docs/conf.py#L54
      #
      # so, we just ignore the resulting errors
      (lib.cmakeBool "SPHINX_WARNINGS_AS_ERRORS" false)
    ]
    ++ lib.optionals finalAttrs.finalPackage.doCheck [
      (lib.cmakeFeature "LLDB_TEST_C_COMPILER" "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc")
      (lib.cmakeFeature "-DLLDB_TEST_CXX_COMPILER" "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++")
    ]
    ++ devExtraCmakeFlags;

    doCheck = false;
    doInstallCheck = false;

    # TODO: cleanup with mass-rebuild
    installCheckPhase = ''
      if [ ! -e ''${!outputLib}/${python3.sitePackages}/lldb/_lldb*.so ] ; then
          echo "ERROR: python files not installed where expected!";
          return 1;
      fi
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
      ln -s $out/bin/*${vscodeExt.name} $out/share/vscode/extensions/llvm-org.${vscodeExt.name}-${vscodeExt.version}/bin
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
      mainProgram = "lldb";
    };
  }
  // lib.optionalAttrs enableManpages {
    pname = "lldb-manpages";

    # TODO: Remove on `staging`.
    buildPhase = "";

    ninjaFlags = [ "docs-lldb-man" ];

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

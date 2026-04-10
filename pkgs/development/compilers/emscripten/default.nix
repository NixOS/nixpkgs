{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  nodejs,
  closurecompiler,
  jre,
  binaryen,
  llvmPackages,
  symlinkJoin,
  makeWrapper,
  replaceVars,
  buildNpmPackage,
  nix-update-script,
  emscripten,
}:

let
  pythonWithPsutil = python3.withPackages (ps: [ ps.psutil ]);
in

stdenv.mkDerivation rec {
  pname = "emscripten";
  version = "4.0.23";

  llvmEnv = symlinkJoin {
    name = "emscripten-llvm-${version}";
    paths = with llvmPackages; [
      clang-unwrapped
      (lib.getLib clang-unwrapped)
      lld
      llvm
    ];
  };

  nodeModules = buildNpmPackage {
    name = "emscripten-node-modules-${version}";
    inherit pname version src;

    npmDepsHash = "sha256-3P4H30nS6RBe2Bd3aqa2ueLOm/hxSBux53GgJu/D4Xc=";

    dontBuild = true;

    # Copy node_modules directly.
    installPhase = ''
      cp -r node_modules $out/
    '';
  };

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten";
    hash = "sha256-i65AWbKuh2KsnugGKmmpUON20He2kgPR6EzwKKA09nQ=";
    rev = version;
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    python3
  ];
  buildInputs = [
    nodejs
  ];

  patches = [
    (replaceVars ./0001-emulate-clang-sysroot-include-logic.patch {
      resourceDir = "${llvmEnv}/lib/clang/${lib.versions.major llvmPackages.llvm.version}/";
    })
  ];

  buildPhase = ''
        runHook preBuild

        # Make Python scripts executable so patchShebangs will patch their shebangs
        chmod +x *.py tools/*.py

        patchShebangs .

        # emscripten 4.0.12 requires LLVM tip-of-tree instead of LLVM 21
        sed -i -e "s/EXPECTED_LLVM_VERSION = 22/EXPECTED_LLVM_VERSION = 21.1/g" tools/shared.py

        # Verify LLVM version patch was applied (fail when nixpkgs has LLVM 22+)
        grep -q "EXPECTED_LLVM_VERSION = 21.1" tools/shared.py || \
          (echo "ERROR: LLVM version patch failed - check if still needed" && exit 1)

        # fixes cmake support
        sed -i -e "s/print \('emcc (Emscript.*\)/sys.stderr.write(\1); sys.stderr.flush()/g" emcc.py

        sed -i "/^def check_sanity/a\\  return" tools/shared.py

        echo "EMSCRIPTEN_ROOT = '$out/share/emscripten'" > .emscripten
        echo "LLVM_ROOT = '${llvmEnv}/bin'" >> .emscripten
        echo "NODE_JS = '${nodejs}/bin/node'" >> .emscripten
        echo "JS_ENGINES = [NODE_JS]" >> .emscripten
        echo "CLOSURE_COMPILER = ['${closurecompiler}/bin/closure-compiler']" >> .emscripten
        echo "JAVA = '${jre}/bin/java'" >> .emscripten
        # to make the test(s) below work
        # echo "SPIDERMONKEY_ENGINE = []" >> .emscripten
        echo "BINARYEN_ROOT = '${binaryen}'" >> .emscripten

        # make emconfigure/emcmake use the correct (wrapped) binaries
        sed -i "s|^EMCC =.*|EMCC='$out/bin/emcc'|" tools/shared.py
        sed -i "s|^EMXX =.*|EMXX='$out/bin/em++'|" tools/shared.py
        sed -i "s|^EMAR =.*|EMAR='$out/bin/emar'|" tools/shared.py
        sed -i "s|^EMRANLIB =.*|EMRANLIB='$out/bin/emranlib'|" tools/shared.py

        # Remove --no-stack-first flag (not in LLVM 21, added in LLVM 22 when --stack-first became default)
        # Replace else block with pass to avoid empty block syntax error
        sed -i "s/cmd.append('--no-stack-first')/pass/" tools/building.py

        # Verify --no-stack-first was removed (fail if patch is no longer needed)
        grep -q "cmd.append('--no-stack-first')" tools/building.py && \
          (echo "ERROR: --no-stack-first patch not needed anymore" && exit 1) || true

        # Fix /tmp symlink issue (macOS: /tmp -> /private/tmp) causing relpath miscalculation
        sed -i 's/os\.path\.relpath(source_dir, build_dir)/os.path.relpath(source_dir, os.path.realpath(build_dir))/' tools/system_libs.py
        sed -i 's/os\.path\.relpath(src, build_dir)/os.path.relpath(src, os.path.realpath(build_dir))/' tools/system_libs.py

        # Verify the relpath fix was applied
        grep -q 'os.path.realpath(build_dir)' tools/system_libs.py || (echo "ERROR: relpath fix not applied" && exit 1)

        # Functional test: verify relpath resolves correctly through symlinks
        ${python3}/bin/python3 -c "
    import os, tempfile
    src = os.path.abspath('tools/system_libs.py')
    with tempfile.TemporaryDirectory() as tmpdir:
        build_dir_real = os.path.realpath(tmpdir)
        relpath = os.path.relpath(src, build_dir_real)
        resolved = os.path.normpath(os.path.join(build_dir_real, relpath))
        assert resolved == src, f'relpath test failed: {resolved} != {src}'
    print('relpath symlink fix test passed')
    "

        runHook postBuild
  '';

  installPhase = ''
        runHook preInstall

        appdir=$out/share/emscripten
        mkdir -p $appdir
        cp -r . $appdir
        chmod -R +w $appdir

        mkdir -p $appdir/node_modules/.bin
        cp -r ${nodeModules}/* $appdir/node_modules
        cp -r ${nodeModules}/* $appdir/node_modules/.bin

        cp ${./locate_cache.sh} $appdir/locate_cache.sh
        chmod +x $appdir/locate_cache.sh

        export EM_CACHE=$out/share/emscripten/cache

        mkdir -p $out/bin

        # Wrap all tools consistently via their .py entry points
        for b in em++ emcc em-config emar embuilder emcmake emconfigure emmake emranlib emrun emscons emsize; do
          makeWrapper $appdir/$b.py $out/bin/$b \
            --set NODE_PATH ${nodeModules} \
            --set EM_EXCLUSIVE_CACHE_ACCESS 1 \
            --set PYTHON ${python3}/bin/python \
            --run "source $appdir/locate_cache.sh"
        done

        # Create extensionless aliases for tools that need them (e.g., file_packager)
        for tool in file_packager; do
          ln -sf $appdir/tools/$tool.py $appdir/tools/$tool
        done

        # Symlinks for CMake toolchain (expects tools in share/emscripten/)
        for tool in emcc em++ em-config emar emranlib emcmake emconfigure; do
          ln -sf $out/bin/$tool $appdir/$tool
        done

        # precompile libc (etc.) in all variants:
        pushd $TMPDIR
        echo 'int __main_argc_argv( int a, int b ) { return 42; }' >test.c
        for LTO in -flto ""; do
          for BIND in "" "--bind"; do
            for PTHREAD in "" "-pthread"; do
              $out/bin/emcc $LTO $BIND $PTHREAD test.c || true
            done
          done
        done
        popd

        export PYTHON=${python3}/bin/python
        export NODE_PATH=${nodeModules}
        pushd $appdir
        ${pythonWithPsutil}/bin/python test/runner.py test_hello_world
        popd

        # fail if any .py files still have unpatched shebangs
        if grep -l '#!/usr/bin/env' $appdir/*.py $appdir/tools/*.py 2>/dev/null; then
          echo "ERROR: unpatched shebangs found in .py files"
        exit 1
    fi

        runHook postInstall
  '';

  passthru = {
    # HACK: Make emscripten look more like a cc-wrapper to GHC
    # when building the javascript backend.
    targetPrefix = "em";
    bintools = emscripten;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "nodeModules"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/emscripten-core/emscripten";
    description = "LLVM-to-JavaScript Compiler";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      qknight
      raitobezarius
      willcohen
    ];
    license = lib.licenses.ncsa;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  emscripten,
}:

stdenv.mkDerivation rec {
  pname = "emscripten";
  version = "4.0.8";

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

    npmDepsHash = "sha256-fGlBtXsYOQ5V4/PRPPIpL3nxb+hUAuj9q7Jw0kL7ph0=";

    dontBuild = true;

    # Copy node_modules directly.
    installPhase = ''
      cp -r node_modules $out/
    '';
  };

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten";
    hash = "sha256-xiqi3SMmlfV7NaA61QZAW7BFHu9xOVN9QMWwwDInBeE=";
    rev = version;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    nodejs
    python3
  ];

  patches = [
    (replaceVars ./0001-emulate-clang-sysroot-include-logic.patch {
      resourceDir = "${llvmEnv}/lib/clang/${lib.versions.major llvmPackages.llvm.version}/";
    })
    # The following patches work around a bug where EM_CACHE is not copied with
    # the correct permissions; the bug will be fixed in the next release (probably 4.0.10).
    # See also: https://github.com/emscripten-core/emscripten/issues/24404
    (fetchpatch {
      url = "https://github.com/emscripten-core/emscripten/commit/99c6e41154f701e423074e33a4fdaf5eea49d073.patch";
      hash = "sha256-/wkhz08NhbgxsrXd7YFfdCGX6LrS2Ncct8dcwxBMsjY=";
    })
    (fetchpatch {
      url = "https://github.com/emscripten-core/emscripten/commit/f4d358d740a238b67a1d6935e71638519d25afa0.patch";
      hash = "sha256-hib5ZAN/R2dH+rTv3nYF37+xKZmeboKxnS+5mkht2lM=";
    })
  ];

  buildPhase = ''
    runHook preBuild

    patchShebangs .

    # emscripten 4 requires LLVM tip-of-tree instead of LLVM 20
    sed -i -e "s/EXPECTED_LLVM_VERSION = 21/EXPECTED_LLVM_VERSION = 20.1/g" tools/shared.py

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

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    appdir=$out/share/emscripten
    mkdir -p $appdir
    cp -r . $appdir
    chmod -R +w $appdir

    mkdir -p $appdir/node_modules
    cp -r ${nodeModules}/* $appdir/node_modules

    mkdir -p $out/bin
    for b in em++ em-config emar embuilder.py emcc emcmake emconfigure emmake emranlib emrun emscons emsize; do
      makeWrapper $appdir/$b $out/bin/$b \
        --set NODE_PATH ${nodeModules} \
        --set EM_EXCLUSIVE_CACHE_ACCESS 1 \
        --set PYTHON ${python3}/bin/python
    done

    # precompile libc (etc.) in all variants:
    pushd $TMPDIR
    echo 'int __main_argc_argv( int a, int b ) { return 42; }' >test.c
    for LTO in -flto ""; do
      for BIND in "" "--bind"; do
        # starting with emscripten 3.1.32+,
        # if pthreads and relocatable are both used,
        # _emscripten_thread_exit_joinable must be exported
        # (see https://github.com/emscripten-core/emscripten/pull/18376)
        # TODO: get library cache to build with both enabled and function exported
        $out/bin/emcc $LTO $BIND test.c
        $out/bin/emcc $LTO $BIND -s RELOCATABLE test.c
        # starting with emscripten 3.1.48+,
        # to use pthreads, _emscripten_check_mailbox must be exported
        # (see https://github.com/emscripten-core/emscripten/pull/20604)
        # TODO: get library cache to build with pthreads at all
        # $out/bin/emcc $LTO $BIND -s USE_PTHREADS test.c
      done
    done
    popd

    export PYTHON=${python3}/bin/python
    export NODE_PATH=${nodeModules}
    pushd $appdir
    python test/runner.py test_hello_world
    popd

    runHook postInstall
  '';

  passthru = {
    # HACK: Make emscripten look more like a cc-wrapper to GHC
    # when building the javascript backend.
    targetPrefix = "em";
    bintools = emscripten;
  };

  meta = with lib; {
    homepage = "https://github.com/emscripten-core/emscripten";
    description = "LLVM-to-JavaScript Compiler";
    platforms = platforms.all;
    maintainers = with maintainers; [
      qknight
      matthewbauer
      raitobezarius
      willcohen
    ];
    license = licenses.ncsa;
  };
}

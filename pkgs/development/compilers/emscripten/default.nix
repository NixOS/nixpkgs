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
  version = "4.0.10";

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

    npmDepsHash = "sha256-kObMqg7hyy7E3F+wbdZoeDy5GOgpE2iNTuDVkFvq5ig=";

    dontBuild = true;

    # Copy node_modules directly.
    installPhase = ''
      cp -r node_modules $out/
    '';
  };

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten";
    hash = "sha256-b+7NYKRm0IsZ2cK2Vqz8zKhqYlxjlhVSdpdFq0LaUPU=";
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

    mkdir -p $appdir/node_modules/.bin
    cp -r ${nodeModules}/* $appdir/node_modules
    cp -r ${nodeModules}/* $appdir/node_modules/.bin

    cp ${./locate_cache.sh} $appdir/locate_cache.sh
    chmod +x $appdir/locate_cache.sh

    export EM_CACHE=$out/share/emscripten/cache

    mkdir -p $out/bin
    for b in em++ em-config emar embuilder.py emcc emcmake emconfigure emmake emranlib emrun emscons emsize; do
      makeWrapper $appdir/$b $out/bin/$b \
        --set NODE_PATH ${nodeModules} \
        --set EM_EXCLUSIVE_CACHE_ACCESS 1 \
        --set PYTHON ${python3}/bin/python \
        --run "source $appdir/locate_cache.sh"
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

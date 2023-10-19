{ lib, stdenv, fetchFromGitHub, python3, nodejs, closurecompiler
, jre, binaryen
, llvmPackages
, symlinkJoin, makeWrapper, substituteAll
, buildNpmPackage
, emscripten
}:

stdenv.mkDerivation rec {
  pname = "emscripten";
  version = "3.1.45";

  llvmEnv = symlinkJoin {
    name = "emscripten-llvm-${version}";
    paths = with llvmPackages; [ clang-unwrapped clang-unwrapped.lib lld llvm ];
  };

  nodeModules = buildNpmPackage {
    name = "emscripten-node-modules-${version}";
    inherit pname version src;

    npmDepsHash = "sha256-kcWAio1fKuwqFCFlupX9KevjWPbv9W/Z/5EPrihQ6ms=";

    dontBuild = true;

    # Copy node_modules directly.
    installPhase = ''
      cp -r node_modules $out/
    '';
  };

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten";
    hash = "sha256-yf0Yb/UjaBQpIEPZzzjaUmR+JzKPSJHMkrYLHxDXwOg=";
    rev = version;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs python3 ];

  patches = [
    (substituteAll {
      src = ./0001-emulate-clang-sysroot-include-logic.patch;
      resourceDir = "${llvmEnv}/lib/clang/16/";
    })
  ];

  buildPhase = ''
    runHook preBuild

    patchShebangs .

    # fixes cmake support
    sed -i -e "s/print \('emcc (Emscript.*\)/sys.stderr.write(\1); sys.stderr.flush()/g" emcc.py

    # disables cache in user home, use installation directory instead
    sed -i '/^def/!s/root_is_writable()/True/' tools/config.py
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
        $out/bin/emcc $LTO $BIND -s USE_PTHREADS test.c
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
    description = "An LLVM-to-JavaScript Compiler";
    platforms = platforms.all;
    maintainers = with maintainers; [ qknight matthewbauer raitobezarius ];
    license = licenses.ncsa;
  };
}

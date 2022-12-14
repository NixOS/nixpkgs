{ lib, stdenv, fetchFromGitHub, python3, nodejs, closurecompiler
, jre, binaryen
, llvmPackages
, symlinkJoin, makeWrapper, substituteAll
, buildNpmPackage
, emscripten
}:

stdenv.mkDerivation rec {
  pname = "emscripten";
  version = "3.1.24";

  llvmEnv = symlinkJoin {
    name = "emscripten-llvm-${version}";
    paths = with llvmPackages; [ clang-unwrapped clang-unwrapped.lib lld llvm ];
  };

  nodeModules = buildNpmPackage {
    name = "emscripten-node-modules-${version}";
    inherit pname version src;

    npmDepsHash = "sha256-ejuHR2BpAUStWjuvQuGE6ko4byF4GBl6FJBshxlknQk=";

    dontBuild = true;

    # Copy node_modules directly.
    installPhase = ''
      cp -r node_modules $out/
    '';
  };

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten";
    sha256 = "sha256-1jW6ThxK6dThOO90l4Mc5yehVF3tI4HWipBWZAOztrk=";
    rev = version;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs python3 ];

  patches = [
    (substituteAll {
      src = ./0001-emulate-clang-sysroot-include-logic.patch;
      resourceDir = "${llvmEnv}/lib/clang/${llvmPackages.release_version}/";
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

    # required for wasm2c
    ln -s ${nodeModules} node_modules

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
    echo 'int __main_argc_argv() { return 42; }' >test.c
    for LTO in -flto ""; do
      # wasm2c doesn't work with PIC
      $out/bin/emcc -s WASM2C -s STANDALONE_WASM $LTO test.c

      for BIND in "" "--bind"; do
        for MT in "" "-s USE_PTHREADS"; do
          for RELOCATABLE in "" "-s RELOCATABLE"; do
            $out/bin/emcc $RELOCATABLE $BIND $MT $LTO test.c
          done
        done
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
    maintainers = with maintainers; [ qknight matthewbauer ];
    license = licenses.ncsa;
  };
}

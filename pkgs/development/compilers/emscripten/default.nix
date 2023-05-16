{ lib, stdenv, fetchFromGitHub, python3, nodejs, closurecompiler
, jre, binaryen
, llvmPackages
<<<<<<< HEAD
, symlinkJoin, makeWrapper, substituteAll
=======
, symlinkJoin, makeWrapper, substituteAll, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildNpmPackage
, emscripten
}:

stdenv.mkDerivation rec {
  pname = "emscripten";
<<<<<<< HEAD
  version = "3.1.45";
=======
  version = "3.1.24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  llvmEnv = symlinkJoin {
    name = "emscripten-llvm-${version}";
    paths = with llvmPackages; [ clang-unwrapped clang-unwrapped.lib lld llvm ];
  };

  nodeModules = buildNpmPackage {
    name = "emscripten-node-modules-${version}";
    inherit pname version src;

<<<<<<< HEAD
    npmDepsHash = "sha256-kcWAio1fKuwqFCFlupX9KevjWPbv9W/Z/5EPrihQ6ms=";
=======
    npmDepsHash = "sha256-ejuHR2BpAUStWjuvQuGE6ko4byF4GBl6FJBshxlknQk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    dontBuild = true;

    # Copy node_modules directly.
    installPhase = ''
      cp -r node_modules $out/
    '';
  };

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten";
<<<<<<< HEAD
    hash = "sha256-yf0Yb/UjaBQpIEPZzzjaUmR+JzKPSJHMkrYLHxDXwOg=";
=======
    sha256 = "sha256-1jW6ThxK6dThOO90l4Mc5yehVF3tI4HWipBWZAOztrk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    rev = version;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs python3 ];

  patches = [
    (substituteAll {
      src = ./0001-emulate-clang-sysroot-include-logic.patch;
<<<<<<< HEAD
      resourceDir = "${llvmEnv}/lib/clang/16/";
=======
      resourceDir = "${llvmEnv}/lib/clang/${llvmPackages.release_version}/";
    })
    # https://github.com/emscripten-core/emscripten/pull/18219
    (fetchpatch {
      url = "https://github.com/emscripten-core/emscripten/commit/afbc14950f021513c59cbeaced8807ef8253530a.patch";
      sha256 = "sha256-+gJNTQJng9rWcGN3GAcMBB0YopKPnRp/r8CN9RSTClU=";
    })
    # https://github.com/emscripten-core/emscripten/pull/18220
    (fetchpatch {
      url = "https://github.com/emscripten-core/emscripten/commit/852982318f9fb692ba1dd1173f62e1eb21ae61ca.patch";
      sha256 = "sha256-hmIOtpRx3PD3sDAahUcreSydydqcdSqArYvyLGgUgd8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
=======
    # required for wasm2c
    ln -s ${nodeModules} node_modules

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

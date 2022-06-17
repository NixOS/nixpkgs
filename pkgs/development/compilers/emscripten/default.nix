{ lib, stdenv, fetchFromGitHub, python3, nodejs, closurecompiler
, jre, binaryen
, llvmPackages
, symlinkJoin, makeWrapper, substituteAll
, mkYarnModules
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "emscripten";
  version = "3.1.10";

  llvmEnv = symlinkJoin {
    name = "emscripten-llvm-${version}";
    paths = with llvmPackages; [ clang-unwrapped clang-unwrapped.lib lld llvm ];
  };

  nodeModules = mkYarnModules {
    name = "emscripten-node-modules-${version}";
    inherit pname version;
    # it is vitally important the the package.json has name and version fields
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
  };

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten";
    sha256 = "03k0pd5hna7khrnn3k3ln38h9w0vyaicfzvfqlqbxi4zz8jikrdb";
    rev = version;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs python3 ];

  patches = [
    (substituteAll {
      src = ./0001-emulate-clang-sysroot-include-logic.patch;
      resourceDir = "${llvmEnv}/lib/clang/${llvmPackages.release_version}/";
    })
    (fetchpatch {
      # https://github.com/emscripten-core/emscripten/pull/16986
      url = "https://github.com/emscripten-core/emscripten/commit/d5ef6937fe395488e23a82c1e582a7ea5c2dab83.patch";
      sha256 = "sha256-YX5DG8i5x6S7XnU58etEapDd+o5SuzbFIGv8v/9+T3E=";
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
    ln -s ${nodeModules}/node_modules .

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
        --set NODE_PATH ${nodeModules}/node_modules \
        --set EM_EXCLUSIVE_CACHE_ACCESS 1 \
        --set PYTHON ${python3}/bin/python
    done

    # precompile libc (etc.) in all variants:
    pushd $TMPDIR
    echo 'int main() { return 42; }' >test.c
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
    export NODE_PATH=${nodeModules}/node_modules
    pushd $appdir
    python tests/runner.py test_hello_world
    popd

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/emscripten-core/emscripten";
    description = "An LLVM-to-JavaScript Compiler";
    platforms = platforms.all;
    maintainers = with maintainers; [ qknight matthewbauer ];
    license = licenses.ncsa;
  };
}

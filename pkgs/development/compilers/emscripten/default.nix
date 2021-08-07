{ lib, stdenv, fetchFromGitHub, python3, nodejs, closurecompiler
, jre, binaryen
, llvmPackages_11
, symlinkJoin, makeWrapper
, mkYarnModules
}:

stdenv.mkDerivation rec {
  pname = "emscripten";
  version = "2.0.10";

  llvmEnv = symlinkJoin {
    name = "emscripten-llvm-${version}";
    paths = with llvmPackages_11; [ clang-unwrapped lld llvm ];
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
    sha256 = "0jy4n1pykk9vkm5da9v3qsfrl6j7yhngcazh2792xxs6wzfcs9gk";
    rev = version;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs python3 ];

  buildPhase = ''
    patchShebangs .

    # fixes cmake support
    sed -i -e "s/print \('emcc (Emscript.*\)/sys.stderr.write(\1); sys.stderr.flush()/g" emcc.py

    # disables cache in user home, use installation directory instead
    sed -i '/^def/!s/root_is_writable()/True/' tools/shared.py
    sed -i "/^def check_sanity/a\\  return" tools/shared.py

    # super ugly: monkeypatch to add sysroot/include to the include
    # path because they are otherwise not part of Nix's clang.
    sed -i "490a\\ '/include'," tools/shared.py

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

    # The tests use the C compiler to compile generated C code,
    # use the wrapped compiler
    sed -i 's/shared.CLANG_CC/"cc"/' tests/runner.py
  '';

  installPhase = ''
    appdir=$out/share/emscripten
    mkdir -p $appdir
    cp -r . $appdir
    chmod -R +w $appdir

    mkdir -p $out/bin
    for b in em++ em-config emar embuilder.py emcc emcmake emconfigure emmake emranlib emrun emscons; do
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
  '';

  meta = with lib; {
    homepage = "https://github.com/emscripten-core/emscripten";
    description = "An LLVM-to-JavaScript Compiler";
    platforms = platforms.all;
    maintainers = with maintainers; [ qknight matthewbauer ];
    license = licenses.ncsa;
  };
}

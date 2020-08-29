{ stdenv, fetchFromGitHub, python3, nodejs, closurecompiler
, jre, binaryen
, llvmPackages_11
, symlinkJoin, makeWrapper
, mkYarnModules
}:

stdenv.mkDerivation rec {
  pname = "emscripten";
  version = "2.0.1";

  llvmEnv = symlinkJoin {
    name = "emscripten-llvm-${version}";
    paths = with llvmPackages_11; [ clang-unwrapped lld llvm ];
  };

  nodeModules = mkYarnModules {
    name = "emscripten-node-modules-${version}";
    inherit pname version;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
  };

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten";
    sha256 = "06dsd819qjv4n2ihrz1mpn5aigmbv0gpkm7iw06wrqx30nzphnpk";
    rev = version;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs python3 ];

  outputs = [ "out" "appdir" ];

  buildPhase = ''
    patchShebangs .
    # fixes cmake support
    sed -i -e "s/print \('emcc (Emscript.*\)/sys.stderr.write(\1); sys.stderr.flush()/g" emcc.py

    echo "EMSCRIPTEN_ROOT = '$appdir'" > .emscripten
    echo "LLVM_ROOT = '${llvmEnv}/bin'" >> .emscripten
    echo "NODE_JS = '${nodejs}/bin/node'" >> .emscripten
    echo "JS_ENGINES = [NODE_JS]" >> .emscripten
    echo "COMPILER_ENGINE = NODE_JS" >> .emscripten
    echo "CLOSURE_COMPILER = '${closurecompiler}/share/java/closure-compiler-v${closurecompiler.version}.jar'" >> .emscripten
    echo "JAVA = '${jre}/bin/java'" >> .emscripten
    # to make the test(s) below work
    echo "SPIDERMONKEY_ENGINE = []" >> .emscripten
    echo "BINARYEN_ROOT = '${binaryen}'" >> .emscripten
  '';

  installPhase = ''
    rm -rf cache
    cp -r . $appdir
    chmod -R +w $appdir

    mkdir -p $out/bin
    for b in em++ em-config emar embuilder.py emcc emcmake emconfigure emlink.py emmake emranlib emrun emscons; do
      makeWrapper $appdir/$b $out/bin/$b \
        --set NODE_PATH ${nodeModules}/node_modules \
        --set PYTHON ${python3}/bin/python
    done
  '';

  doCheck = true;
  checkPhase = ''
    #export EMCC_DEBUG=2
    export PYTHON=${python3}/bin/python
    export HOME=$TMPDIR
    python tests/runner.py test_hello_world
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/emscripten-core/emscripten";
    description = "An LLVM-to-JavaScript Compiler";
    platforms = platforms.all;
    maintainers = with maintainers; [ qknight matthewbauer ];
    license = licenses.ncsa;
  };
}

{ lib, stdenv, fetchFromGitHub, python3, nodejs, closurecompiler, python3Packages
, jre, binaryen
, llvmPackages
, symlinkJoin, makeWrapper, substituteAll
, buildNpmPackage
, emscriptenCache
}: let

executables = "em++ em-config emar emcc emcmake emconfigure emmake emranlib emrun emscons emsize";

in stdenv.mkDerivation rec {
  pname = "emscripten";
  version = "3.1.42";

  llvmEnv = symlinkJoin {
    name = "emscripten-llvm-${version}";
    paths = with llvmPackages; [ clang-unwrapped clang-unwrapped.lib lld llvm ];
  };

  nodeModules = buildNpmPackage {
    name = "emscripten-node-modules-${version}";
    inherit pname version src;

    npmDepsHash = "sha256-QlKm6UvPUa7+VJ9ZvXdxYZzK+U96Ju/oAHPhZ/hyv/I=";

    dontBuild = true;

    # Copy node_modules directly.
    installPhase = ''
      cp -r node_modules $out/
    '';
  };

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten";
    hash = "sha256-elp/LPd9SAuVZy42Wkgb6pCbPi2GnETTfyRJqU92S0E=";
    rev = version;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs python3 ];
  depsBuildBuild = [ closurecompiler jre ];

  patches = [
    (substituteAll {
      src = ./0001-emulate-clang-sysroot-include-logic.patch;
      resourceDir = "${llvmEnv}/lib/clang/16/";
    })
  ];

  buildPhase = ''
    runHook preBuild

    patchShebangs .

    echo "LLVM_ROOT = '${llvmEnv}/bin'" > .emscripten
    echo "NODE_JS = '${nodejs}/bin/node'" >> .emscripten
    echo "JS_ENGINES = [NODE_JS]" >> .emscripten
    echo "CLOSURE_COMPILER = ['$closurecompiler/bin/closure-compiler']" >> .emscripten
    echo "JAVA = '$jre/bin/java'" >> .emscripten
    echo "BINARYEN_ROOT = '${binaryen}'" >> .emscripten

    for b in ${executables}; do
       sed -i $b -e"1a\
       export NODE_PATH=${nodeModules};\
       export PYTHON=${python3}/bin/python;\
       export PYTHONPATH='${python3Packages.makePythonPath [ python3Packages.requests ]}';\
  '' + lib.optionalString (emscriptenCache != null) ''
       export EM_CACHE=${emscriptenCache}/share/emscripten/cache;\
       export EM_FROZEN_CACHE=1;\
  '' + ''
      "
    done

    runHook postBuild
  '';

  doCheck = emscriptenCache != null;
  checkPhase = ''
    runHook preCheck
    python test/runner.py test_hello_world
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    appdir=$out/share/emscripten
    mkdir -p $appdir
    cp -r . $appdir
    chmod -R +w $appdir

    echo "EMSCRIPTEN_ROOT = '$appdir'" >> $appdir/.emscripten

    mkdir -p $out/bin
    for b in ${executables}; do
      makeWrapper $appdir/$b $out/bin/$b
    done
    makeWrapper $appdir/embuilder.py $out/bin/embuilder.py \
      --set NODE_PATH ${nodeModules} \
      --set PYTHON ${python3}/bin/python \
      --set PYTHONPATH '${python3Packages.makePythonPath [ python3Packages.requests ]}'

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/emscripten-core/emscripten";
    description = "An LLVM-to-JavaScript Compiler";
    platforms = platforms.all;
    maintainers = with maintainers; [ qknight matthewbauer raitobezarius atnnn ];
    license = licenses.ncsa;
  };
}

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
  emscripten,
}:

let
  pythonWithPsutil = python3.withPackages (ps: [ ps.psutil ]);
in

stdenv.mkDerivation rec {
  pname = "emscripten";
  version = "4.0.21";

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

    npmDepsHash = "sha256-IwiH+GELJzd4rDq31arhiF5miIRLDe7nrVsM7Yg9rTg=";

    dontBuild = true;

    # Copy node_modules directly.
    installPhase = ''
      cp -r node_modules $out/
    '';
  };

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten";
    hash = "sha256-8lh7ZpzVnoQXOGE/xJgHSWkYXUDOOprbSGaEkyU+vKE=";
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

    patchShebangs .

    # emscripten 4.0.12 requires LLVM tip-of-tree instead of LLVM 21
    sed -i -e "s/EXPECTED_LLVM_VERSION = 22/EXPECTED_LLVM_VERSION = 21.1/g" tools/shared.py

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
    for b in em++ emcc; do
      makeWrapper $appdir/$b $out/bin/$b \
        --set NODE_PATH ${nodeModules} \
        --set EM_EXCLUSIVE_CACHE_ACCESS 1 \
        --set PYTHON ${python3}/bin/python \
        --run "source $appdir/locate_cache.sh"
    done
    for b in em-config emar embuilder emcmake emconfigure emmake emranlib emrun emscons emsize; do
      chmod +x $appdir/$b.py
      makeWrapper $appdir/$b.py $out/bin/$b \
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
        $out/bin/emcc $LTO $BIND test.c
      done
    done
    popd

    export PYTHON=${python3}/bin/python
    export NODE_PATH=${nodeModules}
    pushd $appdir
    ${pythonWithPsutil}/bin/python test/runner.py test_hello_world
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
      raitobezarius
      willcohen
    ];
    license = licenses.ncsa;
  };
}

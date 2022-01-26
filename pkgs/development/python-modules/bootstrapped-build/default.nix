{ stdenv
, lib
, python
, requiredPythonModules
, unzip
, wrapPython

# Bootstrapping deps
, flit-core
, pep517
, tomli
, pyparsing
, six
, installer
, wheel
, setuptools
, packaging
, build
}:

let
  runtimeDeps = [
    build
    setuptools
    wheel
    flit-core
    packaging
    pep517
    tomli
    pyparsing
    six
    installer
  ];
  # runtimeDeps = lib.remove python (requiredPythonModules [ build installer setuptools wheel ]);
  data = map (drv: lib.getAttrs ["pname" "src" ] drv) runtimeDeps;
  # json = builtins.toFile "instructions.json" (builtins.toJSON data);
  srcs = with lib; catAttrs "src" runtimeDeps;
in stdenv.mkDerivation rec {
  name = "${python.libPrefix}-bootstrapped-build-installer";

  inherit srcs;
  sourceRoot = ".";

  postUnpack = ''
    mv pep517* pep517
    mv flit*/flit_core flit_core
    rm -rf flit*source
    mv tomli* tomli
    mv pyparsing* pyparsing
    mv six* six
    mv installer* installer
    mv wheel* wheel
    mv setuptools* setuptools
    mv packaging* packaging
    mv build* build
    for folder in ./*; do
        echo $folder
        export PYTHONPATH="$(pwd)/$folder:$PYTHONPATH"
    done;
    export PYTHONPATH="$(pwd)/tomli/src:$(pwd)/installer/src:$(pwd)/wheel/src:$(pwd)/build/src:$(pwd)/setuptools/pkg_resources:$PYTHONPATH"

  '';

  strictDeps = true;

  nativeBuildInputs = [
    unzip
    wrapPython
    python
  ];

  passthru.bootstrapPackages = srcs;

  buildPhase = ''
    runHook preBuild

    # To get bdist_wheel we need to create an sdist first for some reason
    echo "Building wheel sdist"
    ${python.pythonForBuild.interpreter} -m build --sdist "wheel" --no-isolation --skip-dependency-check

    # Build wheels for all packages
    for pkg in ./*; do
        if [[ -d $pkg ]]; then
          echo "Building $pkg wheel"
          ${python.pythonForBuild.interpreter} -m build --wheel "$pkg" --no-isolation --skip-dependency-check
        fi
    done;

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    # Install our custom install script
    mkdir -p "$out/${python.sitePackages}/install_python_wheel"
    cp ${./install_python_wheel.py} "$out/${python.sitePackages}/install_python_wheel/__main__.py"

    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

    for whl in $(find -name "*.whl"); do
        ${python.pythonForBuild.interpreter} -m install_python_wheel "$whl" --prefix "$out" --prefix-to-remove "${python.pythonForBuild}" --compile-bytecode "0"
    done;

    runHook postInstall
  '';

  postFixup = ''
    wrapPythonPrograms
  '';
}

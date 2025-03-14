{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nodejs,
  notebook,
  ipywidgets,
  ipykernel,
  numpy,
  runCommand,
  jupyter-packaging,
  jupyter-core,
  notebook-shim,
  setuptools-scm,
}:
let
  nodeModules = runCommand "nglview-node-modules" { } ''
    mkdir -p $out/node_modules/@jupyter-widgets/base
    cat > $out/node_modules/@jupyter-widgets/base/package.json <<EOF
    {
      "name": "@jupyter-widgets/base",
      "version": "4.1.1",
      "main": "lib/index.js"
    }
    EOF
  '';
in
buildPythonPackage rec {
  pname = "nglview";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "arose";
    repo = "nglview";
    rev = "v${version}";
    sha256 = "QY7rn6q67noWeoLn0RU2Sn5SeJON+Br/j+aNMlK1PDo=";
  };

  nativeBuildInputs = [
    nodejs
    jupyter-packaging
    jupyter-core
    notebook-shim
    setuptools-scm # Add this line
  ];

  propagatedBuildInputs = [
    notebook
    ipywidgets
    ipykernel
    numpy
  ];

  preBuild = ''
    export HOME=$TMPDIR
    cd js
    cp -r ${nodeModules}/node_modules .
    cd ..
  '';

  postInstall = ''
    mkdir -p $out/share/jupyter/nbextensions
    cp -r nglview/static $out/share/jupyter/nbextensions/nglview-js-widgets
  '';

  meta = with lib; {
    description = "IPython/Jupyter widget to interactively view molecular structures and trajectories";
    homepage = "https://github.com/arose/nglview";
    license = licenses.mit;
    maintainers = with maintainers; [ guelakais ];
  };
}

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
  jupyter_core,
  notebook-shim,
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
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "arose";
    repo = "nglview";
    rev = "v${version}";
    sha256 = "tkRz55W+iGKXZKqnAus3DmspS86td3mMuIVHz3pRCoI=";
  };

  nativeBuildInputs = [
    nodejs
    jupyter-packaging
    jupyter_core
    notebook-shim
  ];

  propagatedBuildInputs = [
    notebook
    ipywidgets
    ipykernel
    numpy
  ];

  postPatch = ''
    substituteInPlace versioneer.py \
      --replace "configparser.SafeConfigParser()" "configparser.ConfigParser()" \
      --replace "parser.readfp(f)" "parser.read_file(f)"
  '';

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
    maintainers = [ ];
  };
}

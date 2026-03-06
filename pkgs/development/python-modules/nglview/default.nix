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
  writableTmpDirAsHomeHook,
  pytestCheckHook,
  mock,
  pillow,
  ase,
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
  version = "4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nglviewer";
    repo = "nglview";
    tag = "v${version}";
    hash = "sha256-Dacsg3+asY0THJ5qrM7+IZCnc2rhCOrbOfN7Xai63Ac=";
  };

  build-system = [
    nodejs
    jupyter-packaging
    jupyter-core
    notebook-shim
    setuptools-scm
    writableTmpDirAsHomeHook
  ];

  dependencies = [
    notebook
    ipywidgets
    ipykernel
    numpy
  ];

  preBuild = ''
    cd js
    cp -r ${nodeModules}/node_modules .
    cd ..
  '';

  pythonImportsCheck = [ "nglview" ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pillow
    ase
  ];

  disabledTests = [
    # requires parmed
    "test_show_schrodinger"
    # requires older moviepy
    "test_movie_maker"
  ];

  postInstall = ''
    mkdir -p $out/share/jupyter/nbextensions
    cp -r nglview/static $out/share/jupyter/nbextensions/nglview-js-widgets
  '';

  meta = {
    description = "IPython/Jupyter widget to interactively view molecular structures and trajectories";
    homepage = "https://github.com/nglviewer/nglview";
    changelog = "https://github.com/nglviewer/nglview/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}

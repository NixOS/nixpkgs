{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
  notebook,
  ipywidgets,
  ipykernel,
  numpy,
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
buildPythonPackage rec {
  pname = "nglview";
  version = "4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LAz/LFseKgpy4zkwh85ErgMIUkxapflTV4EtPtvCboM=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  # NGLview demands numpy < 2.3, but nixpkgs ships >= 2.4
  pythonRelaxDeps = [ "numpy" ];

  build-system = [
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

  meta = {
    description = "IPython/Jupyter widget to interactively view molecular structures and trajectories";
    homepage = "https://github.com/nglviewer/nglview";
    changelog = "https://github.com/nglviewer/nglview/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}

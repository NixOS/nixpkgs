{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  ipykernel,
  jupyter-core,
  jupyter-client,
  pygments,
  pyqt5,
  qtpy,
  traitlets,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "qtconsole";
  version = "5.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "qtconsole";
    rev = "refs/tags/${version}";
    hash = "sha256-esCt7UQ0va/FJ0gdSrcc/k/FgyBVqKy7ttrN6E6mx+E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ipykernel
    jupyter-core
    jupyter-client
    pygments
    pyqt5
    qtpy
    traitlets
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # : cannot connect to X server
  doCheck = false;

  pythonImportsCheck = [ "qtconsole" ];

  meta = {
    description = "Jupyter Qt console";
    mainProgram = "jupyter-qtconsole";
    homepage = "https://qtconsole.readthedocs.io/";
    changelog = "https://qtconsole.readthedocs.io/en/stable/changelog.html#changes-in-jupyter-qt-console";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}

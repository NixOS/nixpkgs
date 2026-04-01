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
  pyqt6,
  qtpy,
  traitlets,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "qtconsole";
  version = "5.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "qtconsole";
    tag = finalAttrs.version;
    hash = "sha256-3NXW/6W0Gr8/LnB6VfHgFWJdwty4gLe2D8YzXn0/Cds=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ipykernel
    jupyter-core
    jupyter-client
    pygments
    pyqt6
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
})

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
  version = "5.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = "qtconsole";
    tag = finalAttrs.version;
    hash = "sha256-GL6CAXijlgc/3nj9KaJJgK+AIq6wHdEf0kpgryJ3KuQ=";
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

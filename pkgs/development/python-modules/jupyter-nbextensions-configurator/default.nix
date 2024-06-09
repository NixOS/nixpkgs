{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jupyter-contrib-core,
  jupyter-core,
  jupyter-server,
  notebook,
  pyyaml,
  tornado,
  pytestCheckHook,
  selenium,
}:

buildPythonPackage rec {
  pname = "jupyter-nbextensions-configurator";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-contrib";
    repo = "jupyter_nbextensions_configurator";
    rev = "refs/tags/${version}";
    hash = "sha256-U4M6pGV/DdE+DOVMVaoBXOhfRERt+yUa+gADgqRRLn4=";
  };

  dependencies = [
    jupyter-contrib-core
    jupyter-core
    jupyter-server
    notebook
    pyyaml
    tornado
  ];

  nativeCheckInputs = [
    pytestCheckHook
    selenium
  ];

  # Those tests fails upstream
  disabledTestPaths = [
    "tests/test_application.py"
    "tests/test_jupyterhub.py"
    "tests/test_nbextensions_configurator.py"
  ];

  pythonImportsCheck = [ "jupyter_nbextensions_configurator" ];

  meta = {
    description = "A jupyter notebook serverextension providing config interfaces for nbextensions";
    mainProgram = "jupyter-nbextensions_configurator";
    homepage = "https://github.com/jupyter-contrib/jupyter_nbextensions_configurator";
    changelog = "https://github.com/Jupyter-contrib/jupyter_nbextensions_configurator/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}

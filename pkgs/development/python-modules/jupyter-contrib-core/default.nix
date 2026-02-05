{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jupyter-core,
  notebook,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jupyter-contrib-core";
  version = "0.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jupyter-contrib";
    repo = "jupyter_contrib_core";
    tag = version;
    hash = "sha256-UTtK+aKxBFkqKuHrt1ox8vdHyFz/9HiKFl7U4UQcG88=";
  };

  propagatedBuildInputs = [
    jupyter-core
    notebook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # This test fails upstream too
    "tests/test_application.py"
  ];

  pythonImportsCheck = [ "jupyter_contrib_core" ];

  meta = {
    description = "Common utilities for jupyter-contrib projects";
    mainProgram = "jupyter-contrib";
    homepage = "https://github.com/jupyter-contrib/jupyter_contrib_core";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}

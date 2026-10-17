{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pyyaml,
  py-cpuinfo,
  psutil,
  qcelemental,
  pydantic,
  pydantic-settings,
  packaging,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.51.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I6Ei0TIylYWordjNAj0wXAxMH1Ayv4p6siJz4F18TA0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyyaml
    py-cpuinfo
    psutil
    qcelemental
    pydantic
    pydantic-settings
    packaging
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "qcengine" ];

  # These tests require network access
  disabledTestPaths = [
    "qcengine/tests/test_harness_canonical.py"
  ];

  meta = {
    description = "Quantum chemistry program executor and IO standardizer (QCSchema) for quantum chemistry";
    homepage = "https://molssi.github.io/QCElemental/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sheepforce ];
    mainProgram = "qcengine";
  };
}

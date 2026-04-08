{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  ipykernel,
  msgpack,
  networkx,
  nglview,
  numpy,
  psutil,
  py-cpuinfo,
  pydantic,
  pytestCheckHook,
  pyyaml,
  qcelemental,
  scipy,
  setuptools,
  setuptools-scm,
  pydantic-settings,
}:

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.34.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e5ofvmlcj2TZndA73rQ+vqf7B7qFfT0X57vHSSgl0+c=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    msgpack
    numpy
    psutil
    py-cpuinfo
    pydantic
    pyyaml
    qcelemental
    pydantic-settings
  ];

  optional-dependencies = {
    align = [
      networkx
      scipy
    ];
    viz = [
      ipykernel
      nglview
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

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

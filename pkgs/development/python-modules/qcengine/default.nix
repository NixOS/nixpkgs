{
  lib,
  buildPythonPackage,
  fetchPypi,
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
}:

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.33.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ute8puO2qc679ttZgzQRnVO8OuBmYnqLT3y7faHpRgA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msgpack
    numpy
    psutil
    py-cpuinfo
    pydantic
    pyyaml
    qcelemental
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

  meta = with lib; {
    description = "Quantum chemistry program executor and IO standardizer (QCSchema) for quantum chemistry";
    homepage = "https://molssi.github.io/QCElemental/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sheepforce ];
    mainProgram = "qcengine";
  };
}

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
}:

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.34.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VKULy45bYn5TmxU7TbOVK98r0pRMWAwissmgx0Ee/8w=";
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

  meta = {
    description = "Quantum chemistry program executor and IO standardizer (QCSchema) for quantum chemistry";
    homepage = "https://molssi.github.io/QCElemental/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sheepforce ];
    mainProgram = "qcengine";
    broken = pythonAtLeast "3.14"; # https://github.com/MolSSI/QCEngine/issues/481
  };
}

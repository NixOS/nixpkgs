{
  lib,
  buildPythonPackage,
  fetchPypi,
  psutil,
  py-cpuinfo,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  qcelemental,
  msgpack,
}:

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.31.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UXddmCObC1H4GQT1eUZEWXDwWg2dE5xaibVq+TAMHk8=";
  };

  propagatedBuildInputs = [
    psutil
    py-cpuinfo
    pydantic
    pyyaml
    qcelemental
    msgpack
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "qcengine" ];

  meta = with lib; {
    description = "Quantum chemistry program executor and IO standardizer (QCSchema) for quantum chemistry";
    mainProgram = "qcengine";
    homepage = "http://docs.qcarchive.molssi.org/projects/qcelemental/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sheepforce ];
  };
}

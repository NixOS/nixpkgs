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
  version = "0.32.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HvvWak7a2djF6wDJaHsBltaG1dTGbKH7wjsngO+fh2U=";
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
    homepage = "https://molssi.github.io/QCElemental/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sheepforce ];
    mainProgram = "qcengine";
  };
}

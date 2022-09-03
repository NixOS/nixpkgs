{ lib
, buildPythonPackage
, fetchPypi
, psutil
, py-cpuinfo
, pydantic
, pytestCheckHook
, pythonOlder
, pyyaml
, qcelemental
}:

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.24.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KUOGbGQd1ffXNkQiW8yeUxValCOAfd8nBv9nnk9giVU=";
  };

  propagatedBuildInputs = [
    psutil
    py-cpuinfo
    pydantic
    pyyaml
    qcelemental
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "qcengine"
  ];

  meta = with lib; {
    description = "Quantum chemistry program executor and IO standardizer (QCSchema) for quantum chemistry";
    homepage = "http://docs.qcarchive.molssi.org/projects/qcelemental/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sheepforce ];
  };
}

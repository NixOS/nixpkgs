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
  version = "0.24.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T6/gC3HHCnI3O1Gkj/MdistL93bwymtEfNF6PmA7TN0=";
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

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
, msgpack
}:

buildPythonPackage rec {
  pname = "qcengine";
  version = "0.29.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cIfX9MpRMXtBfLKHKTzCLkv31fBIyanTQHEs8hHk7aQ=";
  };

  propagatedBuildInputs = [
    psutil
    py-cpuinfo
    pydantic
    pyyaml
    qcelemental
    msgpack
  ];

  nativeCheckInputs = [
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

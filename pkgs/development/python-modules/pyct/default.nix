{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, param
, pytestCheckHook
, pyyaml
, requests
}:

buildPythonPackage rec {
  pname = "pyct";
  version = "0.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23d7525b5a1567535c093aea4b9c33809415aa5f018dd77f6eb738b1226df6f7";
  };

  propagatedBuildInputs = [
    param
    pyyaml
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  doCheck = !isPy27;

  pythonImportsCheck = [
    "pyct"
  ];

  meta = with lib; {
    description = "ClI for Python common tasks for users";
    homepage = "https://github.com/pyviz/pyct";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}

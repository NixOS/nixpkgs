{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pep440";
  version = "0.1.1";
  format = "flit";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E9F4mHaavQKK8PYnRcnOdfW7mXcBKn1dTInCknLeNO4=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pep440"
  ];

  meta = with lib; {
    description = "Python module to check whether versions number match PEP 440";
    homepage = "https://github.com/Carreau/pep440";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

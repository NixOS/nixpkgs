{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pep440";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "m1H/yqqDiFrj6tmD9jo8nDakCBZxkBPq/HtSOXMH4ZQ=";
  };

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

{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.10.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oBNxqQFftcGjxi6y9yULh9FzP87VfwdeMHFeuOFeB10=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "packageurl"
  ];

  meta = with lib; {
    description = "Python parser and builder for package URLs";
    homepage = "https://github.com/package-url/packageurl-python";
    license = licenses.mit;
    maintainers = with maintainers; [ armijnhemel ];
  };
}

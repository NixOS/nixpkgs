{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pybase64";
  version = "1.3.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I0CC/dcDnLdQxkTi03/Ck+c0XqOl8nmrrC9PyWLZuZY=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pybase64" ];

  meta = with lib; {
    description = "Fast Base64 encoding/decoding";
    homepage = "https://github.com/mayeut/pybase64";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}

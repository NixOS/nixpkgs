{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pybase64";
  version = "1.2.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dtB035p7mJs1iZJqsZRmd7uzmez+IwcUsTFX4mM2Ee0=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pybase64" ];

  meta = with lib; {
    description = "Fast Base64 encoding/decoding";
    homepage = "https://github.com/mayeut/pybase64";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}

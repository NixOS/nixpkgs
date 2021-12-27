{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pybase64";
  version = "1.2.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2016a3a487d3d4501d8281f61ee54c25efd65e37a4c7dce8011e0de7183c956";
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

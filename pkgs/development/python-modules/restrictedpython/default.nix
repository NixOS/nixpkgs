{ lib
, buildPythonPackage
, fetchPypi
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "restrictedpython";
  version = "6.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "RestrictedPython";
    inherit version;
    sha256 = "sha256-QFzwvZ7sLxmxMmtfSCKO/lbWWQtOkYJrjMOyzUAKlq0=";
  };

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [
    "RestrictedPython"
  ];

  meta = with lib; {
    description = "Restricted execution environment for Python to run untrusted code";
    homepage = "https://github.com/zopefoundation/RestrictedPython";
    license = licenses.zpl21;
    maintainers = with maintainers; [ juaningan ];
  };
}

{ lib
, fetchPypi
, buildPythonPackage
, aenum
, pythonOlder
, python
}:

buildPythonPackage rec {
  pname = "dbf";
  version = "0.99.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lAJypyrCfRah22mq/vggaEASzDVT/+mHXVzS46nLadw=";
  };

  propagatedBuildInputs = [
    aenum
  ];

  checkPhase = ''
    ${python.interpreter} dbf/test.py
  '';

  pythonImportsCheck = [
    "dbf"
  ];

  meta = with lib; {
    description = "Module for reading/writing dBase, FoxPro, and Visual FoxPro .dbf files";
    homepage = "https://github.com/ethanfurman/dbf";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra ];
  };
}

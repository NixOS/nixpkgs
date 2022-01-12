{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pyparsing
, python
}:

buildPythonPackage rec {
  pname = "aenum";
  version = "3.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LrrYWQtqAYPA2Yk1I7RY7c6YeuRTMznFrBhc+sMtrxo=";
  };

  checkInputs = [
    pyparsing
  ];

  # py2 likes to reorder tests
  doCheck = isPy3k;

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} aenum/test.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "aenum"
  ];

  meta = with lib; {
    description = "Advanced Enumerations (compatible with Python's stdlib Enum), NamedTuples, and NamedConstants";
    homepage = "https://github.com/ethanfurman/aenum";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vrthra ];
  };
}

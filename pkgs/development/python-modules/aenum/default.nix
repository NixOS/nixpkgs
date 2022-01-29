{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pyparsing
, python
}:

buildPythonPackage rec {
  pname = "aenum";
  version = "3.1.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8dbe15f446eb8264b788dfeca163fb0a043d408d212152397dc11377b851e4ae";
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

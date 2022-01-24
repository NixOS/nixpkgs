{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pyparsing
, python
}:

buildPythonPackage rec {
  pname = "aenum";
  version = "3.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ba2c25dd03fbf3992353595be18152e2fb6042f47b526ea66cd5838bb9f1fb6";
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

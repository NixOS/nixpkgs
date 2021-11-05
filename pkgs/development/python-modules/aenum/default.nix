{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pyparsing
, python
}:

buildPythonPackage rec {
  pname = "aenum";
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "806dd4791298e19daff2cdfe7be3ae6d931d0d03097973f802b3ea55066f62dd";
  };

  checkInputs = [
    pyparsing
  ] ;

  # py2 likes to reorder tests
  doCheck = isPy3k;

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} aenum/test.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "aenum" ];

  meta = with lib; {
    description = "Advanced Enumerations (compatible with Python's stdlib Enum), NamedTuples, and NamedConstants";
    maintainers = with maintainers; [ vrthra ];
    license = licenses.bsd3;
    homepage = "https://github.com/ethanfurman/aenum";
  };
}

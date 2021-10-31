{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pyparsing
, python
}:

buildPythonPackage rec {
  pname = "aenum";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75b96aa148e1335eae6c12015563989a675fcbd0bcbd0ae7ce5786329278929b";
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

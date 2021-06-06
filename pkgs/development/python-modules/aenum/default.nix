{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pyparsing
, python
}:

buildPythonPackage rec {
  pname = "aenum";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-h/Dp70+ChXirBq8w5NeUQEO/Ts0/S3vRy+N+IXPN6Uo=";
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

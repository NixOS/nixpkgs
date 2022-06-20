{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pythonOlder
, typing-extensions
, pytest
}:

buildPythonPackage rec {
  pname = "JPype1";
  version = "1.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4fc27dba89750cb0c9d692466341ce60c0fe86a16051091cb5347a37cf884151";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    pytest
  ];

  # required openjdk (easy) but then there were some class path issues
  # when running the tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/originell/jpype/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.asl20;
    description = "A Python to Java bridge";
  };
}

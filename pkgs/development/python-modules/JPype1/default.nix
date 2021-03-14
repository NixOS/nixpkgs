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
  version = "1.2.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f210646127d24be73cfc6d807e2cda1c6b2ab39b7a293008e8b46367af6f2204";
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
    license = licenses.asl20;
    description = "A Python to Java bridge";
  };
}

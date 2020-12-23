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
  version = "1.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "62ca03e7f7963ba4ac1065ee48ff661f752b3db3c23549ed8933ab40196a3157";
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

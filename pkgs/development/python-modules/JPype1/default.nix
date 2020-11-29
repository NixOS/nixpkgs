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
  version = "1.1.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6e36de9f7ef826ff27f6d5260acc710ebc585a534c12cbac905db088ab1d992";
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

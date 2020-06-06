{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "JPype1";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "92f24b0fe11e90b57343494ce38699043d9e6828a22a99dddbcf99c0adb4c1f7";
  };

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

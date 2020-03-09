{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "JPype1";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c16d01cde9c2c955d76d45675e64b06c3255784d49cea4147024e99a01fbbb18";
  };

  checkInputs = [
    pytest
  ];

  # required openjdk (easy) but then there were some class path issues
  # when running the tests
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/originell/jpype/;
    license = licenses.asl20;
    description = "A Python to Java bridge";
  };
}

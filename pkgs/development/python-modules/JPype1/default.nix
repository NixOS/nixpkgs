{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
}:

buildPythonPackage rec {
  pname = "JPype1";
  version = "1.0.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c751436350c105f403e382574d34a6ad73e4a677cb0ff5bc9a87581cc07094e1";
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
    broken = true;
  };
}

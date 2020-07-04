{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
}:

buildPythonPackage rec {
  pname = "JPype1";
  version = "0.7.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7bbd25453dc04704d77d854c80acb5537ecb18b9de8a5572e5f22649a2160aaf";
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

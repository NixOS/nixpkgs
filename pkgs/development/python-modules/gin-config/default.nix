{ lib
, buildPythonPackage
, fetchPypi
, six
, enum34
}:

buildPythonPackage rec {
  pname = "gin-config";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9499c060e1faa340959fc4ada7fe53f643d6f8996a80262b28a082c1ef6849de";

  };

  propagatedBuildInputs = [ six enum34 ];

  # PyPI archive does not ship with tests
  doCheck= false;

  meta = with lib; {
    homepage = "https://github.com/google/gin-config";
    description = "Gin provides a lightweight configuration framework for Python, based on dependency injection.";
    license = licenses.asl20;
    maintainers = with maintainers; [ jethro ];
  };
}

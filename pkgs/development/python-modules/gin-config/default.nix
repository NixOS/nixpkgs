{ lib
, buildPythonPackage
, fetchPypi
, six
, enum34
}:

buildPythonPackage rec {
  pname = "gin-config";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6305325d5afe470fa5a7130883035e51950478b317750205a1532e5413d4ba4c";

  };

  propagatedBuildInputs = [ six enum34 ];

  # PyPI archive does not ship with tests
  doCheck= false;

  meta = with lib; {
    homepage = https://github.com/google/gin-config;
    description = "Gin provides a lightweight configuration framework for Python, based on dependency injection.";
    license = licenses.asl20;
    maintainers = with maintainers; [ jethro ];
  };
}

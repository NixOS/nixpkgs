{ lib
, buildPythonPackage
, fetchPypi
, six
, enum34
}:

buildPythonPackage rec {
  pname = "gin-config";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4e8a2537320240859157870ab58df60e979d936a3c9b17a8b2fa686fc31b287";

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

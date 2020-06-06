{ lib
, buildPythonPackage
, fetchPypi
, six
, enum34
}:

buildPythonPackage rec {
  pname = "gin-config";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a83b7639ae76c276c0380d71d583f151b327a7c37978add314180ec1280a6cc";

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

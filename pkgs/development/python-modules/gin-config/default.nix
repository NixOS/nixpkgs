{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  enum34,
}:

buildPythonPackage rec {
  pname = "gin-config";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DG6lAm3tknyMk8mQsBxpUlfB30RuReVJoVjPvHnhntY=";
  };

  propagatedBuildInputs = [
    six
    enum34
  ];

  # PyPI archive does not ship with tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/google/gin-config";
    description = "Gin provides a lightweight configuration framework for Python, based on dependency injection";
    license = licenses.asl20;
    maintainers = with maintainers; [ jethro ];
  };
}

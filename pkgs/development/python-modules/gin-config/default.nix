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
    sha256 = "0c6ea5026ded927c8c93c990b01c695257c1df446e45e549a158cfbc79e19ed6";
  };

  propagatedBuildInputs = [
    six
    enum34
  ];

  # PyPI archive does not ship with tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/google/gin-config";
    description = "Gin provides a lightweight configuration framework for Python, based on dependency injection.";
    license = licenses.asl20;
    maintainers = with maintainers; [ jethro ];
  };
}

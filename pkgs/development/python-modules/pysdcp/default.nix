{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pysdcp";
  version = "1";
  format = "setuptools";

  src = fetchPypi {
    pname = "pySDCP";
    inherit version;
    hash = "sha256-lR/mfnklyI95Szk0wN7PkoNqXJGG4a2y+hEEYzU1aRw=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysdcp" ];

  meta = {
    description = "Python library to control SONY projectors";
    homepage = "https://github.com/Galala7/pySDCP";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}

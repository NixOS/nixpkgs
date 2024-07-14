{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysdcp";
  version = "1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "pySDCP";
    inherit version;
    hash = "sha256-lR/mfnklyI95Szk0wN7PkoNqXJGG4a2y+hEEYzU1aRw=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysdcp" ];

  meta = with lib; {
    description = "Python library to control SONY projectors";
    homepage = "https://github.com/Galala7/pySDCP";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

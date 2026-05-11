{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyserial,
}:

buildPythonPackage rec {
  pname = "aioserial";
  version = "1.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cCvwOw64S47y2NrFy5JeHmhdzpj3exJVabxv0rO1gig=";
  };

  propagatedBuildInputs = [ pyserial ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioserial" ];

  meta = {
    description = "Python module for async serial communication";
    homepage = "https://github.com/changyuheng/aioserial";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}

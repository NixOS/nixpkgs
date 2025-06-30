{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyserial,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioserial";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cCvwOw64S47y2NrFy5JeHmhdzpj3exJVabxv0rO1gig=";
  };

  propagatedBuildInputs = [ pyserial ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioserial" ];

  meta = with lib; {
    description = "Python module for async serial communication";
    homepage = "https://github.com/changyuheng/aioserial";
    license = licenses.mpl20;
    maintainers = with maintainers; [ fab ];
  };
}

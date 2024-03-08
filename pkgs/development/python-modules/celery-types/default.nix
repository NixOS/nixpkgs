{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "celery-types";
  version = "0.22.0";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DsrS+lpu3tCh+Rnl4eOBzC/wY1/ksh21O0ZhtodtWzA=";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  doCheck = false;

  meta = with lib; {
    description = "PEP-484 stubs for Celery";
    homepage = "https://github.com/sbdchd/celery-types";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}

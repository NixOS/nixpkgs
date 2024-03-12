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
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "celery_types";
    inherit version;
    hash = "sha256-DsrS+lpu3tCh+Rnl4eOBzC/wY1/ksh21O0ZhtodtWzA=";
  };


  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  doCheck = false;

  meta = with lib; {
    description = "PEP-484 stubs for Celery";
    homepage = "https://github.com/sbdchd/celery-types";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}

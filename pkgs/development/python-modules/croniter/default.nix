{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, pytestCheckHook
, pytz
, tzlocal
}:

buildPythonPackage rec {
  pname = "croniter";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CUQi9q657WRnFDk1A/o4iv5PhG4RDhmX/qV5TiCFwtc=";
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  checkInputs = [
    pytestCheckHook
    pytz
    tzlocal
  ];

  pythonImportsCheck = [
    "croniter"
  ];

  meta = with lib; {
    description = "Library to iterate over datetime object with cron like format";
    homepage = "https://github.com/kiorky/croniter";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}

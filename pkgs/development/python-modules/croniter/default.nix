{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, pytestCheckHook
, pytz
, natsort
, tzlocal
}:

buildPythonPackage rec {
  pname = "croniter";
  version = "1.0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06c2smrjskd9di8lcpymcxmygncxr14932qjhslc37yyaafzq3d7";
  };

  propagatedBuildInputs = [
    python-dateutil
    natsort
  ];

  checkInputs = [
    pytestCheckHook
    pytz
    tzlocal
  ];

  pythonImportsCheck = [ "croniter" ];

  meta = with lib; {
    description = "croniter provides iteration for datetime object with cron like format";
    homepage = "https://github.com/kiorky/croniter";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}

{ lib
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, pytestCheckHook
, pytz
, natsort
, tzlocal
}:

buildPythonPackage rec {
  pname = "croniter";
  version = "1.0.15";

  src = fetchFromGitHub {
     owner = "kiorky";
     repo = "croniter";
     rev = "1.0.15";
     sha256 = "1n6nnzyifdy4yc54mj99cvapqz0xr36vhpd29j8ifxk9gl5pj04n";
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

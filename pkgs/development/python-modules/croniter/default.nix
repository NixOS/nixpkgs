{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, pytest
, pytz
, natsort
, tzlocal
}:

buildPythonPackage rec {
  pname = "croniter";
  version = "0.3.32";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d5bf45f12861c1b718c51bd6e2ab056da94e651bf22900658421cdde0ff7088";
  };

  propagatedBuildInputs = [
    python-dateutil
    natsort
  ];

  checkInputs = [
    pytest
    pytz
    tzlocal
  ];

  checkPhase = ''
    pytest src/croniter
  '';

  meta = with lib; {
    description = "croniter provides iteration for datetime object with cron like format";
    homepage = "https://github.com/kiorky/croniter";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}

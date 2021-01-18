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
  version = "0.3.37";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12ced475dfc107bf7c6c1440af031f34be14cd97bbbfaf0f62221a9c11e86404";
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

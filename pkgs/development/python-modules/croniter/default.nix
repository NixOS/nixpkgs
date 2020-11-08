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
  version = "0.3.36";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d3098e50f7edc7480470455d42f09c501fa1bb7e2fc113526ec6e90b068f32c";
  };

  requiredPythonModules = [
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

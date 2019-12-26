{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, pytest
, pytz
}:

buildPythonPackage rec {
  pname = "croniter";
  version = "0.3.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "538adeb3a7f7816c3cdec6db974c441620d764c25ff4ed0146ee7296b8a50590";
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  checkInputs = [
    pytest
    pytz
  ];

  checkPhase = ''
    pytest src/croniter
  '';

  meta = with lib; {
    description = "croniter provides iteration for datetime object with cron like format";
    homepage = https://github.com/kiorky/croniter;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}

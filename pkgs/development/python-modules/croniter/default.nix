{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, pytest
, pytz
}:

buildPythonPackage rec {
  pname = "croniter";
  version = "0.3.31";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15riw8sl8jzzkvvjlz3i3p7jcx423zipxhff5ddvki6zgnrb9149";
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

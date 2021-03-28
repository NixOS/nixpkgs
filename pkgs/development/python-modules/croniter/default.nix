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
  version = "1.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "708532f70584207e23ef2989ca40f367e6238bfe050133a1aff43e1e0e6f6092";
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

  meta = with lib; {
    description = "croniter provides iteration for datetime object with cron like format";
    homepage = "https://github.com/kiorky/croniter";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}

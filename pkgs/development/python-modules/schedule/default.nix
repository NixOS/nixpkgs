{ lib
, buildPythonPackage
, fetchPypi
, mock
}:

buildPythonPackage rec {
  pname = "schedule";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tK1peq+6cYTJ62oeLrxB94FUckKs3ozq6aCiWwTAki0=";
  };

  buildInputs = [ mock ];

  preCheck = ''
    # https://github.com/dbader/schedule/issues/488
    substituteInPlace test_schedule.py --replace \
      "self.assertRaises(ScheduleValueError, every().day.until, datetime.time(hour=5))" \
      "# self.assertRaises(ScheduleValueError, every().day.until, datetime.time(hour=5))"
  '';

  meta = with lib; {
    description = "Python job scheduling for humans";
    homepage = "https://github.com/dbader/schedule";
    changelog = "https://github.com/dbader/schedule/blob/${version}/HISTORY.rst";
    license = licenses.mit;
  };
}

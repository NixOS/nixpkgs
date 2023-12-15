{ lib
, buildPythonPackage
, fetchPypi
, mock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "schedule";
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hDvAU4uZyT8CuLUOPjmIbAby0AOyT0jhqkyt+j80Enk=";
  };

  buildInputs = [
    mock
  ];

  preCheck = ''
    # https://github.com/dbader/schedule/issues/488
    substituteInPlace test_schedule.py --replace \
      "self.assertRaises(ScheduleValueError, every().day.until, datetime.time(hour=5))" \
      "# self.assertRaises(ScheduleValueError, every().day.until, datetime.time(hour=5))"
  '';

  pythonImportsCheck = [
    "schedule"
  ];

  meta = with lib; {
    description = "Python job scheduling for humans";
    homepage = "https://github.com/dbader/schedule";
    changelog = "https://github.com/dbader/schedule/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

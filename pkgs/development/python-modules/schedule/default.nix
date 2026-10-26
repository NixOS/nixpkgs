{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "schedule";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Ff6cdf5f2blifz8ZzA7xQgUI+fmkb0XNB2nvde3l8Lc=";
  };

  preCheck = ''
    # https://github.com/dbader/schedule/issues/488
    substituteInPlace test_schedule.py --replace \
      "self.assertRaises(ScheduleValueError, every().day.until, datetime.time(hour=5))" \
      "# self.assertRaises(ScheduleValueError, every().day.until, datetime.time(hour=5))"
  '';

  pythonImportsCheck = [ "schedule" ];

  meta = {
    description = "Python job scheduling for humans";
    homepage = "https://github.com/dbader/schedule";
    changelog = "https://github.com/dbader/schedule/blob/${finalAttrs.version}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

{ lib, buildPythonPackage, fetchPypi, isPy27
, nose, chai, simplejson, backports_functools_lru_cache
, python-dateutil, pytz, pytest-mock, sphinx, dateparser, pytestcov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff08d10cda1d36c68657d6ad20d74fbea493d980f8b2d45344e00d6ed2bf6ed4";
  };

  propagatedBuildInputs = [ python-dateutil ]
    ++ lib.optionals isPy27 [ backports_functools_lru_cache ];

  checkInputs = [
    dateparser
    pytestCheckHook
    pytestcov
    pytest-mock
    pytz
    simplejson
    sphinx
  ];

  # ParserError: Could not parse timezone expression "America/Nuuk"
  disabledTests = [
    "test_parse_tz_name_zzz"
  ];

  meta = with lib; {
    description = "Python library for date manipulation";
    homepage = "https://github.com/crsmithdev/arrow";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}

{ lib, buildPythonPackage, fetchPypi, pythonOlder
, simplejson, typing-extensions, python-dateutil, pytz, pytest-mock, sphinx
, dateparser, pytestcov, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "1.0.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0793badh4hgbk2c5g70hmbl7n3d4g5d87bcflld0w9rjwy59r71r";
  };

  propagatedBuildInputs = [ python-dateutil ]
    ++ lib.optionals (!pythonOlder "3.8") [ typing-extensions ];

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
    maintainers = with maintainers; [ thoughtpolice oxzi ];
  };
}

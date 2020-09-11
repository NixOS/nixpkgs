{ stdenv, lib, buildPythonPackage, fetchPypi, isPy27
, nose, chai, simplejson, backports_functools_lru_cache
, python-dateutil, pytz, pytest-mock, sphinx, dateparser, pytestcov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "0.15.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "edc31dc051db12c95da9bac0271cd1027b8e36912daf6d4580af53b23e62721a";
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

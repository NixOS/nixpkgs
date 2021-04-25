{ lib, buildPythonPackage, fetchPypi, isPy27
, nose, chai, simplejson, backports_functools_lru_cache
, python-dateutil, pytz, pytest-mock, sphinx, dateparser, pytestcov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "399c9c8ae732270e1aa58ead835a79a40d7be8aa109c579898eb41029b5a231d";
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

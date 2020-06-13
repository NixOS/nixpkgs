{ stdenv, lib, buildPythonPackage, fetchPypi, isPy27
, nose, chai, simplejson, backports_functools_lru_cache
, python-dateutil, pytz, pytest-mock, sphinx, dateparser, pytestcov, pytest
}:

buildPythonPackage rec {
  pname = "arrow";
  version = "0.15.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb5d339f00072cc297d7de252a2e75f272085d1231a3723f1026d1fa91367118";
  };

  propagatedBuildInputs = [ python-dateutil ]
    ++ lib.optionals isPy27 [ backports_functools_lru_cache ];

  checkInputs = [
    dateparser
    pytest
    pytestcov
    pytest-mock
    pytz
    simplejson
    sphinx
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Python library for date manipulation";
    homepage = "https://github.com/crsmithdev/arrow";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}

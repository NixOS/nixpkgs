{ stdenv, buildPythonPackage, fetchPypi, python, isPy27
, six
}:

buildPythonPackage rec {
  pname = "querystring_parser";
  version = "1.2.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "644fce1cffe0530453b43a83a38094dbe422ccba8c9b2f2a1c00280e14ca8a62";
  };

  propagatedBuildInputs = [
    six
  ];

  checkPhase = "${python.interpreter} querystring_parser/tests.py -k 'not test_parse_normalized'";
  # one test fails due to https://github.com/bernii/querystring-parser/issues/35
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/bernii/querystring-parser";
    description = "QueryString parser for Python/Django that correctly handles nested dictionaries";
    license = licenses.mit;
    maintainers = with maintainers; [ tbenst ];
  };
}

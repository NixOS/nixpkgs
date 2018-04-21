{ buildPythonPackage, python, lib, fetchPypi
, isPy3k
, requests
}:

buildPythonPackage rec {
  pname = "pylibgen";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rviqi3rf62b43cabdy8c2cdznjv034mp0qrfrzvkih4jlkhyfrh";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests ];

  # It's not using unittest
  checkPhase = "${python.interpreter} tests/test_pylibgen.py -c 'test_api_endpoints()'";

  meta = {
    description = "Python interface to Library Genesis";
    homepage = https://pypi.org/project/pylibgen/;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nico202 ];
  };
}

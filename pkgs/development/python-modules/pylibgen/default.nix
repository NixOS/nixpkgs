{ buildPythonPackage, python, lib, fetchPypi
, isPy3k
, requests
}:

buildPythonPackage rec {
  pname = "pylibgen";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c2a82b47cb7225dcf4ecea27081b0185ae4d195499140cdbb9597d914e1ae9e";
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

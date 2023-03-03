{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, brotli }:

buildPythonPackage rec {
  pname = "Logbook";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s1gyfw621vid7qqvhddq6c3z2895ci4lq3g0r1swvpml2nm9x36";
  };

  nativeCheckInputs = [ pytest ] ++ lib.optionals (!isPy3k) [ mock ];

  propagatedBuildInputs = [ brotli ];

  checkPhase = ''
    find tests -name \*.pyc -delete
    py.test tests
  '';

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://pythonhosted.org/Logbook/";
    description = "A logging replacement for Python";
    license = lib.licenses.bsd3;
  };
}

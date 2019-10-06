{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, brotli }:

buildPythonPackage rec {
  pname = "Logbook";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mvsig6sk4dywpw5naah1npf6h621qzhg0sd427j5znr06a2ksqs";
  };

  checkInputs = [ pytest ] ++ lib.optionals (!isPy3k) [ mock ];

  propagatedBuildInputs = [ brotli ];

  checkPhase = ''
    find tests -name \*.pyc -delete
    py.test tests
  '';

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = https://pythonhosted.org/Logbook/;
    description = "A logging replacement for Python";
    license = lib.licenses.bsd3;
  };
}

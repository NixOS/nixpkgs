{ lib, buildPythonPackage, fetchPypi, pythonPackages }:

buildPythonPackage rec {
  pname = "rfc6555";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "123905b8f68e2bec0c15f321998a262b27e2eaadea29a28bd270021ada411b67";
  };

  propagatedBuildInputs = with pythonPackages; [ selectors2 ];

  checkInputs = with pythonPackages; [ mock pytest ];
  # disabling tests that require a functional DNS IPv{4,6} stack to pass.
  patches = [ ./disable_network_tests.patch ];
  # default doCheck = true; is not enough, apparently
  postCheck = ''
    py.test tests/
  '';

  meta = with lib; {
    description = "Python implementation of the Happy Eyeballs Algorithm";
    homepage = "https://pypi.org/project/rfc6555";
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
  };
}

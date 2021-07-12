{ lib, buildPythonPackage, fetchPypi, pythonPackages }:

buildPythonPackage rec {
  pname = "rfc6555";
  version = "0.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05sjrd6jc0sdvx0z7d3llk82rx366jlmc7ijam0nalsv66hbn70r";
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

{ lib, buildPythonPackage, fetchPypi
, pytest, setuptools-scm, tempora, pytest-black, pytest-cov }:

buildPythonPackage rec {
  pname = "portend";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "986ed9a278e64a87b5b5f4c21e61c25bebdce9919a92238d9c14c37a7416482b";
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace "--flake8" ""
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ tempora ];

  checkInputs = [ pytest pytest-black pytest-cov ];

  checkPhase = ''
    py.test --deselect=test_portend.py::TestChecker::test_check_port_listening
  '';

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Monitor TCP ports for bound or unbound states";
    homepage = "https://github.com/jaraco/portend";
    license = licenses.bsd3;
  };
}

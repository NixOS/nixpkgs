{ lib, buildPythonPackage, fetchPypi
, pytest, setuptools-scm, tempora, pytest-black, pytest-cov }:

buildPythonPackage rec {
  pname = "portend";
  version = "2.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fbc0df9e4970b661e4d7386a91fc7bcf34ebeaf0333ce15d819d515a71ba8b2";
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

{ lib, buildPythonPackage, fetchPypi
, pytest, setuptools_scm, tempora, pytest-black, pytestcov }:

buildPythonPackage rec {
  pname = "portend";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac0e57ae557f75dc47467579980af152e8f60bc2139547eff8469777d9110379";
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace "--flake8" ""
  '';

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ tempora ];

  checkInputs = [ pytest pytest-black pytestcov ];

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

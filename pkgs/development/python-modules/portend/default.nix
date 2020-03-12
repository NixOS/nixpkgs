{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools_scm, tempora, pytest-black, pytestcov }:

buildPythonPackage rec {
  pname = "portend";
  version = "2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "600dd54175e17e9347e5f3d4217aa8bcf4bf4fa5ffbc4df034e5ec1ba7cdaff5";
  };

  patches = [ ./black-19.10b0.patch ];
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

  meta = with stdenv.lib; {
    description = "Monitor TCP ports for bound or unbound states";
    homepage = https://github.com/jaraco/portend;
    license = licenses.bsd3;
  };
}

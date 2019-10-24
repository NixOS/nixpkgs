{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools_scm, tempora, pytest-black }:

buildPythonPackage rec {
  pname = "portend";
  version = "2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19dc27bfb3c72471bd30a235a4d5fbefef8a7e31cab367744b5d87a205e7bfd9";
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace "--flake8" ""
  '';

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ tempora ];

  checkInputs = [ pytest pytest-black ];

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

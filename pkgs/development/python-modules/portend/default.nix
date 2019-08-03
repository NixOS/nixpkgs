{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools_scm, tempora }:

buildPythonPackage rec {
  pname = "portend";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7ce7d35ea262415297cbfea86226513e77b9ee5f631d3baa11992d663963719";
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace "--flake8" ""
  '';

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ tempora ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test --deselect=test_portend.py::TestChecker::test_check_port_listening
  '';

  meta = with stdenv.lib; {
    description = "Monitor TCP ports for bound or unbound states";
    homepage = https://github.com/jaraco/portend;
    license = licenses.bsd3;
  };
}

{ lib, buildPythonPackage, fetchPypi, isPy3k
, setuptools_scm
, cheroot, portend, more-itertools, zc_lockfile, routes
, objgraph, pytest, pytestcov, pathpy, requests_toolbelt, pytest-services
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "18.1.1";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    sha256 = "6585c19b5e4faffa3613b5bf02c6a27dcc4c69a30d302aba819639a2af6fa48b";
  };

  propagatedBuildInputs = [
    # required
    cheroot portend more-itertools zc_lockfile
    # optional
    routes
  ];

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [
    objgraph pytest pytestcov pathpy requests_toolbelt pytest-services
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = https://www.cherrypy.org;
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

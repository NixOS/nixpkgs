{ lib, buildPythonPackage, fetchPypi, isPy3k
, setuptools_scm
, cheroot, portend, more-itertools, zc_lockfile, routes
, objgraph, pytest, pytestcov, pathpy, requests_toolbelt, pytest-services
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "18.1.2";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    sha256 = "1w3hpsg7q8shdmscmbqk00w90lcw3brary7wl1a56k5h7nx33pj8";
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

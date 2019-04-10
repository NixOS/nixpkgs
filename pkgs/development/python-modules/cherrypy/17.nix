{ lib, buildPythonPackage, fetchPypi
, setuptools_scm
, cheroot, contextlib2, portend, routes, six, zc_lockfile
, backports_unittest-mock, objgraph, pathpy, pytest, pytestcov, backports_functools_lru_cache, requests_toolbelt
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "17.4.1";

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    sha256 = "1kl17anzz535jgkn9qcy0c2m0zlafph0iv7ph3bb9mfrs2bgvagv";
  };

  propagatedBuildInputs = [
    cheroot contextlib2 portend routes six zc_lockfile
  ];

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [
    backports_unittest-mock objgraph pathpy pytest pytestcov backports_functools_lru_cache requests_toolbelt
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

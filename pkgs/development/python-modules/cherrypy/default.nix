{ lib, buildPythonPackage, fetchPypi
, cheroot, contextlib2, portend, routes, six
, setuptools_scm, zc_lockfile
, backports_unittest-mock, objgraph, pathpy, pytest, pytestcov
, backports_functools_lru_cache, requests_toolbelt
}:

buildPythonPackage rec {
  pname = "CherryPy";
  version = "18.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3002fc47b982c3df4d08dbe5996b093fd73f85b650ab8df19e8b9b95f5c00520";
  };

  propagatedBuildInputs = [ cheroot contextlib2 portend routes six zc_lockfile ];

  buildInputs = [ setuptools_scm ];

  checkInputs = [ backports_unittest-mock objgraph pathpy pytest pytestcov backports_functools_lru_cache requests_toolbelt ];

  checkPhase = ''
    LANG=en_US.UTF-8 pytest
  '';

  meta = with lib; {
    homepage = "http://www.cherrypy.org";
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

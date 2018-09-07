{ lib, buildPythonPackage, fetchPypi
, cheroot, contextlib2, portend, routes, six
, setuptools_scm, zc_lockfile
, backports_unittest-mock, objgraph, pathpy, pytest, pytestcov
, backports_functools_lru_cache, requests_toolbelt
}:

buildPythonPackage rec {
  pname = "CherryPy";
  version = "17.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3e4d76232ade4c47666b9008f92556465df517b8dca833ece3bed027028ae7d";
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

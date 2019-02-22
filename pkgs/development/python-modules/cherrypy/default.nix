{ lib, buildPythonPackage, fetchPypi, isPy3k
, cheroot, contextlib2, portend, routes, six
, setuptools_scm, zc_lockfile, more-itertools
, backports_unittest-mock, objgraph, pathpy, pytest, pytestcov
, backports_functools_lru_cache, requests_toolbelt, pytest-services
}:

let
  srcInfo = if isPy3k then {
    version = "18.1.0";
    sha256 = "4dd2f59b5af93bd9ca85f1ed0bb8295cd0f5a8ee2b84d476374d4e070aa5c615";
  } else {
    version = "17.4.1";
    sha256 = "1kl17anzz535jgkn9qcy0c2m0zlafph0iv7ph3bb9mfrs2bgvagv";
  };
in buildPythonPackage rec {
  pname = "CherryPy";
  inherit (srcInfo) version;

  src = fetchPypi {
    inherit pname;
    inherit (srcInfo) version sha256;
  };

  propagatedBuildInputs = if isPy3k then [
    # required
    cheroot portend more-itertools zc_lockfile
    # optional
    routes
  ] else [
    cheroot contextlib2 portend routes six zc_lockfile
  ];

  buildInputs = [ setuptools_scm ];

  checkInputs = if isPy3k then [
    objgraph pytest pytestcov pathpy requests_toolbelt pytest-services
  ] else [
    backports_unittest-mock objgraph pathpy pytest pytestcov backports_functools_lru_cache requests_toolbelt
  ];

  checkPhase = ''
    # 3 out of 5 SignalHandlingTests need network access
    LANG=en_US.UTF-8 pytest -k "not SignalHandlingTests and not test_4_Autoreload"
  '';

  meta = with lib; {
    homepage = "http://www.cherrypy.org";
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

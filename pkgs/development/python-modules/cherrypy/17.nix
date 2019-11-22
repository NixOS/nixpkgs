{ stdenv, buildPythonPackage, fetchPypi
, setuptools_scm
, cheroot, contextlib2, portend, routes, six, zc_lockfile
, backports_unittest-mock, objgraph, pathpy, pytest, pytestcov, backports_functools_lru_cache, requests_toolbelt
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "17.4.2";

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    sha256 = "ef1619ad161f526745d4f0e4e517753d9d985814f1280e330661333d2ba05cdf";
  };

  propagatedBuildInputs = [
    cheroot contextlib2 portend routes six zc_lockfile
  ];

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [
    backports_unittest-mock objgraph pathpy pytest pytestcov backports_functools_lru_cache requests_toolbelt
  ];

  checkPhase = ''
    pytest --deselect=cherrypy/test/test_static.py::StaticTest::test_null_bytes ${stdenv.lib.optionalString stdenv.isDarwin "--ignore=cherrypy/test/test_wsgi_unix_socket.py"}
  '';

  meta = with stdenv.lib; {
    homepage = https://www.cherrypy.org;
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

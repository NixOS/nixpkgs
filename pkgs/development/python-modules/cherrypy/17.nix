{ lib, stdenv, buildPythonPackage, fetchPypi
, setuptools-scm
, cheroot, contextlib2, portend, routes, six, zc_lockfile
, backports_unittest-mock, objgraph, pathpy, pytest, pytest-cov, backports_functools_lru_cache, requests-toolbelt
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

  nativeBuildInputs = [ setuptools-scm ];

  checkInputs = [
    backports_unittest-mock objgraph pathpy pytest pytest-cov backports_functools_lru_cache requests-toolbelt
  ];

  checkPhase = ''
    pytest ${lib.optionalString stdenv.isDarwin "--ignore=cherrypy/test/test_wsgi_unix_socket.py"}
  '';

  meta = with lib; {
    homepage = "https://www.cherrypy.org";
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

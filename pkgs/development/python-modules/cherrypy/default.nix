{ lib, stdenv, buildPythonPackage, fetchPypi, isPy3k
, setuptools-scm
, cheroot, portend, more-itertools, zc_lockfile, routes
, jaraco_collections
, objgraph, pytest, pytest-cov, pathpy, requests-toolbelt, pytest-services
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "18.6.1";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    sha256 = "sha256-8z6HKG57PjCeBOciXY5JOC2dd3PmCSJB1/YTiTxWNJU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    # required
    cheroot portend more-itertools zc_lockfile
    jaraco_collections
    # optional
    routes
  ];

  checkInputs = [
    objgraph pytest pytest-cov pathpy requests-toolbelt pytest-services pytestCheckHook
  ];

  # Keyboard interrupt ends test suite run
  # daemonize and autoreload tests have issue with sockets within sandbox
  # Disable doctest plugin because times out
  preCheck = ''
    # from the arch package, had to add it to fix the tests
    rm -rf ./{,cherrypy/}{pytest.ini,tox.ini}
    export WEBTEST_INTERACTIVE=0
  '';

  disabledTests = [
    "testCombinedTools"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_block"
    "test_config_server"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "https://www.cherrypy.org";
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

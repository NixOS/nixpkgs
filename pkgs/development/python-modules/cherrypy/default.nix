{ lib
, stdenv
, buildPythonPackage
, cheroot
, fetchPypi
, jaraco_collections
, more-itertools
, objgraph
, pathpy
, portend
, pytest-forked
, pytest-services
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, requests-toolbelt
, routes
, setuptools-scm
, simplejson
, zc_lockfile
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "18.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    hash = "sha256-8z6HKG57PjCeBOciXY5JOC2dd3PmCSJB1/YTiTxWNJU=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    # required
    cheroot
    portend
    more-itertools
    zc_lockfile
    jaraco_collections
    # optional
    routes
    simplejson
  ];

  checkInputs = [
    objgraph
    pathpy
    pytest-forked
    pytest-services
    pytestCheckHook
    requests-toolbelt
  ];

  preCheck = ''
    # Disable doctest plugin because times out
    substituteInPlace pytest.ini \
      --replace "--doctest-modules" "-vvv"
    sed -i "/--cov/d" pytest.ini
  '';

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTests = [
    # Keyboard interrupt ends test suite run
    "KeyboardInterrupt"
    # daemonize and autoreload tests have issue with sockets within sandbox
    "daemonize"
    "Autoreload"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_block"
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "cherrypy/test/test_config_server.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "cherrypy"
  ];

  meta = with lib; {
    description = "Object-oriented HTTP framework";
    homepage = "https://www.cherrypy.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}

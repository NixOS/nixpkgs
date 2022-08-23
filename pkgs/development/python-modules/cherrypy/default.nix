{ lib
, stdenv
, buildPythonPackage
, cheroot
, fetchPypi
, jaraco_collections
, more-itertools
, objgraph
, path
, portend
, pytest-forked
, pytest-services
, pytestCheckHook
, python-memcached
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
  version = "18.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    hash = "sha256-cpRS95jKdWOQBG7zGAQ8roZKRoFN6vPmvTTclZrxmN4=";
  };

  postPatch = ''
    # Disable doctest plugin because times out
    substituteInPlace pytest.ini \
      --replace "--doctest-modules" "-vvv" \
      --replace "-p pytest_cov" "" \
      --replace "--no-cov-on-fail" ""
    sed -i "/--cov/d" pytest.ini
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cheroot
    portend
    more-itertools
    zc_lockfile
    jaraco_collections
  ];

  checkInputs = [
    objgraph
    path
    pytest-forked
    pytest-services
    pytestCheckHook
    requests-toolbelt
  ];

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

    "test_antistampede"
    "test_file_stream"
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

  passthru.optional-dependencies = {
    json = [ simplejson ];
    memcached_session = [ python-memcached ];
    routes_dispatcher = [ routes ];
    # not packaged yet
    xcgi = [ /* flup */ ];
  };

  meta = with lib; {
    description = "Object-oriented HTTP framework";
    homepage = "https://www.cherrypy.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}

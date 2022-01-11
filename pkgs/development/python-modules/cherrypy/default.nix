{ lib, stdenv, buildPythonPackage, fetchPypi, pythonOlder
, setuptools-scm
, cheroot, portend, more-itertools, zc_lockfile, routes
, jaraco_collections
, objgraph, pytest, pytest-cov, pathpy, requests-toolbelt, pytest-services
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
    cheroot portend more-itertools zc_lockfile
    jaraco_collections
    # optional
    routes
  ];

  checkInputs = [
    objgraph pytest pytest-cov pathpy requests-toolbelt pytest-services
  ];

  
  # daemonize and autoreload tests have issue with sockets within sandbox
  # Disable doctest plugin because times out
  preCheck = ''
    substituteInPlace pytest.ini --replace "--doctest-modules" ""
    pytest \
      -k 'not KeyboardInterrupt and not daemonize and not Autoreload' \
      --deselect=cherrypy/test/test_static.py::StaticTest::test_null_bytes \
      --deselect=cherrypy/test/test_tools.py::ToolTests::testCombinedTools \
      ${lib.optionalString stdenv.isDarwin
        "--deselect=cherrypy/test/test_bus.py::BusMethodTests::test_block --deselect=cherrypy/test/test_config_server.py"}
  '';

  disabledTests = [
    # Keyboard interrupt ends test suite run
    ""
    ""
    ""
    ""
  ];

  disabledTestPaths = [
    ""
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

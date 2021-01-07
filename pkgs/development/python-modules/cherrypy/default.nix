{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, setuptools_scm
, cheroot, portend, more-itertools, zc_lockfile, routes
, jaraco_collections
, objgraph, pytest, pytestcov, pathpy, requests_toolbelt, pytest-services
, fetchpatch
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "18.6.0";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    sha256 = "16f410izp2c4qhn4n3l5l3qirmkf43h2amjqms8hkl0shgfqwq2n";
  };

  propagatedBuildInputs = [
    # required
    cheroot portend more-itertools zc_lockfile
    jaraco_collections
    # optional
    routes
  ];

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [
    objgraph pytest pytestcov pathpy requests_toolbelt pytest-services
  ];

  # Keyboard interrupt ends test suite run
  # daemonize and autoreload tests have issue with sockets within sandbox
  # Disable doctest plugin because times out
  checkPhase = ''
    substituteInPlace pytest.ini --replace "--doctest-modules" ""
    pytest \
      -k 'not KeyboardInterrupt and not daemonize and not Autoreload' \
      --deselect=cherrypy/test/test_static.py::StaticTest::test_null_bytes \
      --deselect=cherrypy/test/test_tools.py::ToolTests::testCombinedTools \
      ${stdenv.lib.optionalString stdenv.isDarwin
        "--deselect=cherrypy/test/test_bus.py::BusMethodTests::test_block"}
  '';

  __darwinAllowLocalNetworking = true;

  meta = with stdenv.lib; {
    homepage = "https://www.cherrypy.org";
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

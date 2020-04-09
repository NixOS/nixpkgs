{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, setuptools_scm
, cheroot, portend, more-itertools, zc_lockfile, routes
, objgraph, pytest, pytestcov, pathpy, requests_toolbelt, pytest-services, jaraco_collections
, fetchpatch
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "18.5.0";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    sha256 = "0ayj2s4ldps7shxs7rwr6wiz666dhlilwkmx8lhi2sf470fgdck3";
  };

  propagatedBuildInputs = [
    # required
    cheroot portend more-itertools zc_lockfile jaraco_collections
    # optional
    routes
  ];

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [
    objgraph pytest pytestcov pathpy requests_toolbelt pytest-services
  ];

  # Disable doctest plugin because times out
  checkPhase = ''
    substituteInPlace pytest.ini --replace "--doctest-modules" ""
    pytest ${stdenv.lib.optionalString stdenv.isDarwin "--deselect=cherrypy/test/test_bus.py::BusMethodTests::test_block"} \
      --deselect=cherrypy/test/test_static.py::StaticTest::test_null_bytes \
      --deselect=cherrypy/test/test_tools.py::ToolTests::testCombinedTools
  '';

  meta = with stdenv.lib; {
    homepage = https://www.cherrypy.org;
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

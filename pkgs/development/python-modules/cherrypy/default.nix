{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, setuptools_scm
, cheroot, portend, more-itertools, zc_lockfile, routes
, objgraph, pytest, pytestcov, pathpy, requests_toolbelt, pytest-services
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "18.1.2";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    sha256 = "1w3hpsg7q8shdmscmbqk00w90lcw3brary7wl1a56k5h7nx33pj8";
  };

  propagatedBuildInputs = [
    # required
    cheroot portend more-itertools zc_lockfile
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
    pytest --deselect=cherrypy/test/test_static.py::StaticTest::test_null_bytes ${stdenv.lib.optionalString stdenv.isDarwin "--deselect=cherrypy/test/test_bus.py::BusMethodTests::test_block"}
  '';

  meta = with stdenv.lib; {
    homepage = https://www.cherrypy.org;
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

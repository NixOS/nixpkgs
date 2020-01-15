{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, setuptools_scm
, cheroot, portend, more-itertools, zc_lockfile, routes
, objgraph, pytest, pytestcov, pathpy, requests_toolbelt, pytest-services
, fetchpatch
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

  # Remove patches once 96b34df and 14c12d2
  # become part of a release - they're currently only present in master.
  # ref: https://github.com/cherrypy/cherrypy/pull/1791
  patches = [
    (fetchpatch {
      name = "pytest5-1.patch";
      url = "https://github.com/cherrypy/cherrypy/commit/96b34dfea7853b0189bc0a3878b6ddff0d4e505c.patch";
      sha256 = "0zy53mahffgkpd844118b42lsk5lkjmig70d60x1i46w6gnr61mi";
    })
    (fetchpatch {
      name = "pytest5-2.patch";
      url = "https://github.com/cherrypy/cherrypy/commit/14c12d2420a4b3765bb241250bd186e93b2f25eb.patch";
      sha256 = "0ihcz7b5myn923rq5665b98pz52hnf6fcys2y2inf23r3i07scyz";
    })
  ];

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

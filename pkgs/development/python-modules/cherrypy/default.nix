{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, setuptools_scm
, cheroot, portend, more-itertools, zc_lockfile, routes
, objgraph, pytest, pytestcov, pathpy, requests_toolbelt, pytest-services
, fetchpatch
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "18.3.0";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    sha256 = "0q6cs4vrv0rwim4byxfizrlp4h6hmwg3n4baz0ga66vvgiz6hgk8";
  };

  # Remove patches once 88d2163 and 713f672
  # become part of a release - they're currently only present in master.
  # ref: https://github.com/cherrypy/cherrypy/pull/1820
  patches = [
    (fetchpatch {
      name = "test_HTTP11_Timeout.patch";
      url = "https://github.com/cherrypy/cherrypy/commit/88d21630f68090c56d07000cabb6df4f1b612a71.patch";
      sha256 = "1i6a3qs3ijyd9rgsxb8axigkzdlmr5sl3ljif9rvn0d90211bzwh";
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
    pytest \
      --deselect=cherrypy/test/test_static.py::StaticTest::test_null_bytes \
      --deselect=cherrypy/test/test_tools.py::ToolTests::testCombinedTools \
      ${stdenv.lib.optionalString stdenv.isDarwin
        "--deselect=cherrypy/test/test_bus.py::BusMethodTests::test_block"}
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.cherrypy.org";
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

{ lib, stdenv, buildPythonPackage, fetchPypi, isPy3k
, setuptools-scm
, cheroot, portend, more-itertools, zc_lockfile, routes
, jaraco_collections
, objgraph, pytest, pytest-cov, pathpy, requests-toolbelt, pytest-services
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

  patches = [
    # 1/3 Fix compatibility with pytest 6. Will be part of the next release after 18.6
    (fetchpatch {
      url = "https://github.com/cherrypy/cherrypy/pull/1897/commits/59c0e19d7df8680e36afc96756dce72435121448.patch";
      sha256 = "1jachbvp505gndccdhny0c3grzdrmvmbzq4kw55jx93ay94ni6p0";
    })
    # 2/3 Fix compatibility with pytest 6. Will be part of the next release after 18.6
    (fetchpatch {
      url = "https://github.com/cherrypy/cherrypy/pull/1897/commits/4a6287b73539adcb7b0ae72d69644a1ced1f7eaa.patch";
      sha256 = "0nz40qmgxknkbjsdzfzcqfxdsmsxx3v104fb0h04yvs76mqvw3i4";
    })
    # 3/3 Fix compatibility with pytest 6. Will be part of the next release after 18.6
    (fetchpatch {
      url = "https://github.com/cherrypy/cherrypy/commit/3bae7f06868553b006915f05ff14d86163f59a7d.patch";
      sha256 = "1z0bv23ybyw87rf1i8alsdi3gc2bzmdj9d0kjsghdkvi3zdp4n8q";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

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

  # Keyboard interrupt ends test suite run
  # daemonize and autoreload tests have issue with sockets within sandbox
  # Disable doctest plugin because times out
  checkPhase = ''
    substituteInPlace pytest.ini --replace "--doctest-modules" ""
    pytest \
      -k 'not KeyboardInterrupt and not daemonize and not Autoreload' \
      --deselect=cherrypy/test/test_static.py::StaticTest::test_null_bytes \
      --deselect=cherrypy/test/test_tools.py::ToolTests::testCombinedTools \
      ${lib.optionalString stdenv.isDarwin
        "--deselect=cherrypy/test/test_bus.py::BusMethodTests::test_block --deselect=cherrypy/test/test_config_server.py"}
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "https://www.cherrypy.org";
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

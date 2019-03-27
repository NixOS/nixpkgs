{ lib, buildPythonPackage, fetchPypi, isPy3k
, setuptools_scm
, cheroot, portend, more-itertools, zc_lockfile, routes
, objgraph, pytest, pytestcov, pathpy, requests_toolbelt, pytest-services
}:

buildPythonPackage rec {
  pname = "cherrypy";
  version = "18.1.0";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "CherryPy";
    inherit version;
    sha256 = "4dd2f59b5af93bd9ca85f1ed0bb8295cd0f5a8ee2b84d476374d4e070aa5c615";
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

  checkPhase = ''
    # test_2_File_Concurrency also fails upstream: https://github.com/cherrypy/cherrypy/issues/1306
    # ...and skipping it makes 2 other tests fail
    pytest -k "not test_2_File_Concurrency and not test_3_Redirect and not test_4_File_deletion"
  '';

  meta = with lib; {
    homepage = https://www.cherrypy.org;
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

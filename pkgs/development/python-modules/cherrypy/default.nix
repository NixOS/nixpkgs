{ lib, buildPythonPackage, fetchPypi
, cheroot, portend, routes, six
, setuptools_scm
, backports_unittest-mock, objgraph, pathpy, pytest, pytestcov
, backports_functools_lru_cache, requests_toolbelt
}:

buildPythonPackage rec {
  pname = "CherryPy";
  version = "16.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "858fbff27235a392026b1d821ad815b587815c94fbb14312e2e64cc23766b9c3";
  };

  propagatedBuildInputs = [ cheroot portend routes six ];

  buildInputs = [ setuptools_scm ];

  checkInputs = [ backports_unittest-mock objgraph pathpy pytest pytestcov backports_functools_lru_cache requests_toolbelt ];

  checkPhase = ''
    LANG=en_US.UTF-8 pytest
  '';

  meta = with lib; {
    homepage = "http://www.cherrypy.org";
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

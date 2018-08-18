{ lib, buildPythonPackage, fetchPypi
, cheroot, portend, routes, six
, setuptools_scm
, backports_unittest-mock, objgraph, pathpy, pytest, pytestcov
, backports_functools_lru_cache, requests_toolbelt
}:

buildPythonPackage rec {
  pname = "CherryPy";
  version = "17.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3cdb5fbae183db49ab1f1a90643d521aa060c93f90001cc99c19d8d15b7a3fb7";
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

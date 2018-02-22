{ lib, buildPythonPackage, fetchPypi
, cheroot, portend, routes, six
, setuptools_scm
, backports_unittest-mock, codecov, coverage, objgraph, pathpy, pytest, pytest-sugar, pytestcov
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "CherryPy";
  version = "14.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f5ee020d6547a8d452b3560775ca2374ffe2ff8c0aec1b272e93b6af80d850e";
  };

  propagatedBuildInputs = [ cheroot portend routes six ];

  buildInputs = [ setuptools_scm ];

  checkInputs = [ backports_unittest-mock codecov coverage objgraph pathpy pytest pytest-sugar pytestcov ];

  checkPhase = ''
    LANG=en_US.UTF-8 pytest
  '';

  meta = with lib; {
    homepage = "http://www.cherrypy.org";
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

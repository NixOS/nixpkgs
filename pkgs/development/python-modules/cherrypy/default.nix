{ lib, buildPythonPackage, fetchPypi
, cheroot, portend, routes, six
, setuptools_scm
, backports_unittest-mock, codecov, coverage, objgraph, pathpy, pytest, pytest-sugar, pytestcov
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "CherryPy";
  version = "13.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pb9mfmhns33jq4nrd38mv88ha74fj3q0y2mm8qsjh7ywphvk9ap";
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

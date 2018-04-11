{ lib, buildPythonPackage, fetchPypi
, cheroot, portend, routes, six
, setuptools_scm
, backports_unittest-mock, codecov, coverage, objgraph, pathpy, pytest, pytest-sugar, pytestcov
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "CherryPy";
  version = "14.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "721d09bbeedaf5b3493e9e644ae9285d776ea7f16b1d4a0a5aaec7c0d22e5074";
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

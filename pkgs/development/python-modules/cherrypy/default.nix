{ lib, buildPythonPackage, fetchPypi
, cheroot, portend, routes, six
, setuptools_scm
, backports_unittest-mock, objgraph, pathpy, pytest, pytestcov
}:

buildPythonPackage rec {
  pname = "CherryPy";
  version = "15.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7404638da9cf8c6be672505168ccb63e16d33cb3aa16a02ec30a44641f7546af";
  };

  propagatedBuildInputs = [ cheroot portend routes six ];

  buildInputs = [ setuptools_scm ];

  checkInputs = [ backports_unittest-mock objgraph pathpy pytest pytestcov ];

  checkPhase = ''
    LANG=en_US.UTF-8 pytest
  '';

  meta = with lib; {
    homepage = "http://www.cherrypy.org";
    description = "A pythonic, object-oriented HTTP framework";
    license = licenses.bsd3;
  };
}

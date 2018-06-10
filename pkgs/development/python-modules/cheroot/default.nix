{ stdenv, fetchPypi, buildPythonPackage
, more-itertools, six
, pytest, pytestcov, portend
, backports_unittest-mock, setuptools_scm }:

buildPythonPackage rec {
  pname = "cheroot";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10s67wxymk4xg45l7ca59n4l6m6rnj8b9l52pg1angxh958lwixs";
  };

  propagatedBuildInputs = [ more-itertools six ];

  buildInputs = [ setuptools_scm ];

  checkInputs = [ pytest pytestcov portend backports_unittest-mock ];

  checkPhase = ''
    py.test cheroot
  '';

  meta = with stdenv.lib; {
    description = "High-performance, pure-Python HTTP";
    homepage = https://github.com/cherrypy/cheroot;
    license = licenses.mit;
  };
}

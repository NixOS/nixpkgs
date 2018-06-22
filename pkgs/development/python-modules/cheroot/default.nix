{ stdenv, fetchPypi, buildPythonPackage
, more-itertools, six
, pytest, pytestcov, portend
, backports_unittest-mock, setuptools_scm }:

buildPythonPackage rec {
  pname = "cheroot";
  version = "6.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "52f915d077ce6201e59c95c4a2ef89617d9b90e6185defb40c03ff3515d2066f";
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

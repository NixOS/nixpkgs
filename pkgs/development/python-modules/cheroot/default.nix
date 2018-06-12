{ stdenv, fetchPypi, buildPythonPackage
, more-itertools, six
, pytest, pytestcov, portend
, backports_unittest-mock, setuptools_scm }:

buildPythonPackage rec {
  pname = "cheroot";
  version = "6.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e83ecc6bd473c340a10adac19cc69c65607638fa3e8b37cf0b26b6fdf4db4994";
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

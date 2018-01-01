{ stdenv, fetchPypi, buildPythonPackage
, six
, coverage, codecov, pytest, pytestcov, pytest-sugar, portend
, backports_unittest-mock, setuptools_scm }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "cheroot";
  version = "5.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c6476ed8f12354c2785594965bad693060716335280d6d60013f56f38032af8";
  };

  propagatedBuildInputs = [ six ];
  buildInputs = [ coverage codecov pytest pytestcov pytest-sugar portend backports_unittest-mock setuptools_scm ];

  checkPhase = ''
    py.test cheroot
  '';

  meta = with stdenv.lib; {
    description = "High-performance, pure-Python HTTP";
    homepage = https://github.com/cherrypy/cheroot;
    license = licenses.mit;
  };
}

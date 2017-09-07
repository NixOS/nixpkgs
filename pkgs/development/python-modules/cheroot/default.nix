{ stdenv, fetchPypi, buildPythonPackage
, six
, coverage, codecov, pytest, pytestcov, pytest-sugar, portend
, backports_unittest-mock, setuptools_scm }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "cheroot";
  version = "5.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fhyk8lgs2blfx4zjvwsy6f0ynrs5fwnnr3qf07r6c4j3gwlkqsr";
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

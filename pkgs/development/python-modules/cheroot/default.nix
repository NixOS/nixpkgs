{ stdenv, fetchPypi, buildPythonPackage
, six
, coverage, codecov, pytest, pytestcov, pytest-sugar, portend
, backports_unittest-mock, setuptools_scm }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "cheroot";
  version = "5.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c0531fd732700b1fb3e6e7079dc3aefbdf29e9136925633d93f009cb87d70a3";
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

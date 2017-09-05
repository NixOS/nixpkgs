{ stdenv, buildPythonPackage, fetchPypi, termcolor, pytest }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-sugar";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11lni9kn0r1y896xg20qjv4yjcyr56h0hx9dprdgjnam4dqcl6lg";
  };

  propagatedBuildInputs = [ termcolor pytest ];

  meta = with stdenv.lib; {
    description = "A plugin that changes the default look and feel of py.test";
    homepage = https://github.com/Frozenball/pytest-sugar;
    license = licenses.bsd3;
  };
}

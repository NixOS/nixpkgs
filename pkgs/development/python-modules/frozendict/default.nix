{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "frozendict";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ibf1wipidz57giy53dh7mh68f2hz38x8f4wdq88mvxj5pr7jhbp";
  };

  # frozendict does not come with tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/slezica/python-frozendict";
    description = "An immutable dictionary";
    license = licenses.mit;
  };
}

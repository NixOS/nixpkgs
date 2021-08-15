{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f00de72805cf4c9e81b334f3f04809278b967d2fed84552313a0fcce511beb1";
  };

  # frozendict does not come with tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/slezica/python-frozendict";
    description = "An immutable dictionary";
    license = licenses.mit;
  };
}

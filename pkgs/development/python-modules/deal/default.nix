{ lib, fetchPypi, buildPythonPackage, pythonOlder, astroid, vaa, hypothesis }:

buildPythonPackage rec {
  pname = "deal";
  version = "4.21.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-ARZRh2Ve3EaVg2FDSfdlSkrKv7GLpB2gx/NLeB54mP4=";
  };

  doCheck = false;

  propagatedBuildInputs = [ vaa astroid hypothesis ];

  meta = with lib; {
    description =
      "Deal is a Python library for design by contract (DbC) programming.";
    homepage = "https://github.com/life4/deal";
    license = licenses.mit;
  };
}

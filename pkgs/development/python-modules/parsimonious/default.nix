{ lib
, buildPythonPackage
, fetchPypi
, regex
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "parsimonious";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sq0a5jovZb149eCorFEKmPNgekPx2yqNRmNqXZ5KMME=";
  };

  propagatedBuildInputs = [
    regex
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "parsimonious"
    "parsimonious.grammar"
    "parsimonious.nodes"
  ];

  meta = with lib; {
    homepage = "https://github.com/erikrose/parsimonious";
    description = "Fast arbitrary-lookahead parser written in pure Python";
    license = licenses.mit;
  };

}

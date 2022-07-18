{ lib
, buildPythonPackage
, fetchPypi
, regex
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "parsimonious";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sq0a5jovZb149eCorFEKmPNgekPx2yqNRmNqXZ5KMME=";
  };

  propagatedBuildInputs = [
    regex
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "regex>=2022.3.15" "regex"
  '';

  pythonImportsCheck = [
    "parsimonious"
    "parsimonious.grammar"
    "parsimonious.nodes"
  ];

  meta = with lib; {
    description = "Arbitrary-lookahead parser";
    homepage = "https://github.com/erikrose/parsimonious";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

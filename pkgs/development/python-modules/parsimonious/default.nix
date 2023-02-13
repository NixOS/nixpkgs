{ lib
, buildPythonPackage
, fetchPypi
, regex
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "parsimonious";
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-goFgDaGA7IrjVCekq097gr/sHj0eUvgMtg6oK5USUBw=";
  };

  propagatedBuildInputs = [
    regex
  ];

  nativeCheckInputs = [
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

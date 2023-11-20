{ lib
, buildPythonPackage
, fetchFromGitHub
, bitstruct
, diskcache
, prompt-toolkit
, pyparsing
, python
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asn1tools";
  version = "0.166.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "asn1tools";
    rev = version;
    hash = "sha256-TWAOML6nsLX3TYqoQ9fcSjrUmC4byXOfczfkmSaSa0k=";
  };

  propagatedBuildInputs = [
    bitstruct
    pyparsing
  ];

  passthru.optional-depdendencies = {
    shell = [
      prompt-toolkit
    ];
    cache = [
      diskcache
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-depdendencies);


  pythonImportsCheck = [
    "asn1tools"
  ];

  meta = with lib; {
    description = "ASN.1 parsing, encoding and decoding";
    homepage = "https://github.com/eerimoq/asn1tools";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

{ lib
, buildPythonPackage
, fetchFromGitHub
, bitstruct
, diskcache
, prompt-toolkit
, pyparsing
, python
, pythonOlder
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
    diskcache
    prompt-toolkit
    pyparsing
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  pythonImportsCheck = [
    "asn1tools"
  ];

  meta = with lib; {
    description = "ASN.1 parsing, encoding and decoding";
    homepage = "https://github.com/eerimoq/asn1tools";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

{ lib
, buildPythonPackage
, fetchFromGitHub
, bitstruct
, diskcache
, prompt-toolkit
, pyparsing
, python
}:

buildPythonPackage rec {
  pname = "asn1tools";
  version = "0.163.0";

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "asn1tools";
    rev = "v${version}";
    sha256 = "sha256-sbwwbwkhlZvCb2emuw1FTBj5pnv9SOtHpAcYPSQqIvM=";
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

  pythonImportsCheck = [ "asn1tools" ];

  meta = with lib; {
    description = "ASN.1 parsing, encoding and decoding";
    homepage = "https://github.com/eerimoq/asn1tools";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

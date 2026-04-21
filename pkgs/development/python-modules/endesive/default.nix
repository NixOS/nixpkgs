{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  asn1crypto,
  cryptography,
  certifi,
  pytz,
  lxml,
  pillow,
  pykcs11,
  requests,
  paramiko,
}:

buildPythonPackage rec {
  pname = "endesive";
  version = "2.19.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m32";
    repo = "endesive";
    rev = "v${version}";
    hash = "sha256-two1W4mmHL5HV8k+skpa6X/KcaLx78Y6WSlazW75sRo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    asn1crypto
    cryptography
    certifi
    pytz
  ];

  passthru.optional-dependencies = {
    full = [
      lxml
      pillow
      pykcs11
      requests
      paramiko
    ];
  };

  doCheck = false;

  pythonImportsCheck = [
    "endesive"
  ];

  meta = {
    description = "Library for digital signing and verification of digital signatures in mail, PDF and XML documents";
    homepage = "https://github.com/m32/endesive";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ruiiiijiiiiang ];
  };
}

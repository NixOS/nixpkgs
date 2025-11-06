{
  lib,
  aiohttp,
  asn1crypto,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  freezegun,
  oscrypto,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  uritools,
}:

buildPythonPackage rec {
  pname = "pyhanko-certvalidator";
  version = "0.26.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "certvalidator";
    tag = "v${version}";
    hash = "sha256-Gvahyuz3n/CNAEzMXS5Z0Z85yDqLUQu8Yis5oJ2jaKc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    cryptography
    oscrypto
    requests
    uritools
  ];

  nativeCheckInputs = [
    aiohttp
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyhanko_certvalidator" ];

  meta = with lib; {
    description = "Python library for validating X.509 certificates and paths";
    homepage = "https://github.com/MatthiasValvekens/certvalidator";
    changelog = "https://github.com/MatthiasValvekens/certvalidator/blob/v${version}/changelog.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}

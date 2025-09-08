{
  lib,
  aiosmtpd,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  hatchling,
  pytest-asyncio_0,
  pytestCheckHook,
  pythonOlder,
  trustme,
}:

buildPythonPackage rec {
  pname = "aiosmtplib";
  version = "4.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "cole";
    repo = "aiosmtplib";
    tag = "v${version}";
    hash = "sha256-DHZyed94XgixMTeKQ7Lj4oykL42HMmEMSdNGRHCiRvM=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    aiosmtpd
    hypothesis
    pytest-asyncio_0
    pytestCheckHook
    trustme
  ];

  pythonImportsCheck = [ "aiosmtplib" ];

  meta = with lib; {
    description = "Module which provides a SMTP client";
    homepage = "https://github.com/cole/aiosmtplib";
    changelog = "https://github.com/cole/aiosmtplib/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

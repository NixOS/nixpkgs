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
  version = "5.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "cole";
    repo = "aiosmtplib";
    tag = "v${version}";
    hash = "sha256-ICG7yVH2UcvQAsVGbxu7LibWUj/NEPV/f5iDc25XuzU=";
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

  meta = {
    description = "Module which provides a SMTP client";
    homepage = "https://github.com/cole/aiosmtplib";
    changelog = "https://github.com/cole/aiosmtplib/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}

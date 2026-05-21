{
  lib,
  aiosmtpd,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  hatchling,
  pytest-asyncio_0,
  pytestCheckHook,
  trustme,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiosmtplib";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cole";
    repo = "aiosmtplib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+aMtU8ea8yy1jxPPQGSu4kW3PX9N9qYQ90CSduPPgYc=";
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
    changelog = "https://github.com/cole/aiosmtplib/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})

{
  lib,
  aiosmtpd,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  trustme,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiosmtplib";
  version = "5.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cole";
    repo = "aiosmtplib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-izU4m+XgXYvS9vxlf5I5RWwuQGIoLlef7/Es5N5u7WI=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    aiosmtpd
    hypothesis
    pytest-asyncio
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

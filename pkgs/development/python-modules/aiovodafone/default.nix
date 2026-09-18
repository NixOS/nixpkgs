{
  lib,
  aiohttp,
  beautifulsoup4,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  orjson,
  pycryptodome,
  pytest-cov-stub,
  pytestCheckHook,
  segno,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiovodafone";
  version = "3.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiovodafone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7m22ALnuLKScbsG7BdiyehEU2VjalGy3DhCvwDUMA5w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    beautifulsoup4
    cryptography
    orjson
    pycryptodome
    segno
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiovodafone" ];

  meta = {
    description = "Library to control Vodafon Station";
    homepage = "https://github.com/chemelli74/aiovodafone";
    changelog = "https://github.com/chemelli74/aiovodafone/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})

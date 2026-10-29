{
  lib,
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  fetchFromGitHub,
  openssl,
  orjson,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiovitesy";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiovitesy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dbTgwtv+jxaYFgwEYUij0uANFyQ+J+G85b54ZPrSr9Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aiomqtt
    orjson
  ];

  nativeCheckInputs = [
    openssl
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiovitesy" ];

  meta = {
    description = "Python library to control Vitesy devices";
    homepage = "https://github.com/chemelli74/aiovitesy";
    changelog = "https://github.com/chemelli74/aiovitesy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})

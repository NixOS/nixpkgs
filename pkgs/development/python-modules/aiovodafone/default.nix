{
  lib,
  aiohttp,
  beautifulsoup4,
  buildPythonPackage,
  colorlog,
  cryptography,
  fetchFromGitHub,
  orjson,
  poetry-core,
  pycryptodome,
  pytest-cov-stub,
  pytestCheckHook,
  segno,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiovodafone";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiovodafone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ip3bvK8p9BUs1t2BEwNdoqcDlATu39zIxRjvJCqfNHE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    beautifulsoup4
    colorlog
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

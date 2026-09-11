{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  httpx,
  pytest-aiohttp,
  pytest-mock,
  pytestCheckHook,
  respx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ha-philipsjs";
  version = "3.3.4"; # FIXME Can we check metadata again?
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = "ha-philipsjs";
    tag = version;
    hash = "sha256-Ui15KtTpyfVTHmiHNVx/99qiUtKLZeyOOtAuQvfnU8k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    httpx
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-mock
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "haphilipsjs" ];

  # the tag 3.3.4 actually corresponds to version 3.2.4
  dontCheckPythonMetadata = true;

  meta = {
    description = "Library to interact with Philips TVs with jointSPACE API";
    homepage = "https://github.com/danielperna84/ha-philipsjs";
    changelog = "https://github.com/danielperna84/ha-philipsjs/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}

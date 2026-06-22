{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  gql,
  oathtool,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "monarchmoneycommunity";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bradleyseanf";
    repo = "monarchmoneycommunity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WWwxCL5LNIMqt+K2AmFuCQtx/i7MtyCsTxagz1GMw+g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    gql
    oathtool
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "monarchmoney" ];

  meta = {
    description = "Monarch Money API for Python";
    homepage = "https://github.com/bradleyseanf/monarchmoneycommunity";
    changelog = "https://github.com/bradleyseanf/monarchmoneycommunity/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})

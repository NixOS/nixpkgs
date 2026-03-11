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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bradleyseanf";
    repo = "monarchmoneycommunity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xJKsA6YCcwWeqGiNYuMUjrPnj1kYtR6odB/JU1vZ/3c=";
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

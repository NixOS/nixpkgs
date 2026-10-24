{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  gql,
  oathtool,
  gitMinimal,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "monarchmoneycommunity";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bradleyseanf";
    repo = "monarchmoneycommunity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xy/Qk0lbr/RGRpQy4B88mN8iyxp2ONh9yknVRmaANuY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    gql
    oathtool
  ];

  nativeCheckInputs = [
    gitMinimal
    pytestCheckHook
  ];

  pythonImportsCheck = [ "monarchmoney" ];

  meta = {
    description = "Monarch Money API for Python";
    homepage = "https://github.com/bradleyseanf/monarchmoneycommunity";
    changelog = "https://github.com/bradleyseanf/monarchmoneycommunity/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})

{
  lib,
  aiohttp,
  azure-core,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  microsoft-kiota-abstractions,
  opentelemetry-api,
  opentelemetry-sdk,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "microsoft-kiota-authentication-azure";
  version = "1.11.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-authentication-azure-v${finalAttrs.version}";
    hash = "sha256-KF3KRcD8KP7MFtw5SgP84UVxNxOnW/VzEGmM92V16GE=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/authentication/azure/";

  build-system = [ flit-core ];

  dependencies = [
    aiohttp
    azure-core
    microsoft-kiota-abstractions
    opentelemetry-api
    opentelemetry-sdk
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kiota_authentication_azure" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "microsoft-kiota-authentication-azure-v";
  };

  meta = {
    description = "Kiota Azure authentication provider";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/authentication/azure";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-authentication-azure-${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})

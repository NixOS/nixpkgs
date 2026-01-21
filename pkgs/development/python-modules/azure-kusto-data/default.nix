{
  lib,
  aiohttp,
  asgiref,
  azure-core,
  azure-identity,
  buildPythonPackage,
  fetchFromGitHub,
  ijson,
  msal,
  pandas,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-kusto-data";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-kusto-python";
    tag = "v${version}";
    hash = "sha256-ZwPF6YLb2w+Thds36UeQdx64SJqKHFXSQVv39YYQOHA=";
  };

  sourceRoot = "${src.name}/${pname}";

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    azure-identity
    ijson
    msal
    python-dateutil
    requests
  ];

  optional-dependencies = {
    aio = [
      aiohttp
      asgiref
    ];
    pandas = [ pandas ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "azure.kusto.data" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/aio/test_async_token_providers.py"
    "tests/test_token_providers.py"
    "tests/test_e2e_data.py"
  ];

  meta = {
    description = "Kusto Data Client";
    homepage = "https://pypi.org/project/azure-kusto-data/";
    changelog = "https://github.com/Azure/azure-kusto-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

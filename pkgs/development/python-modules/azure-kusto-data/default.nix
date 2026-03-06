{
  lib,
  aiohttp,
  aioresponses,
  asgiref,
  azure-core,
  azure-identity,
  buildPythonPackage,
  fetchFromGitHub,
  ijson,
  msal,
  pandas,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  requests,
  uv-build,
}:

buildPythonPackage rec {
  pname = "azure-kusto-data";
  version = "6.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-kusto-python";
    tag = "v${version}";
    hash = "sha256-jg8VueMohp7z45va5Z+cF0Hz+RMW4Vd5AchJX/wngLc=";
  };

  sourceRoot = "${src.name}/${pname}";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.9,<0.9.0" uv_build
  '';

  build-system = [ uv-build ];

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
    aioresponses
    pytest-asyncio
    pytest-xdist
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
    homepage = "https://github.com/Azure/azure-kusto-python/tree/master/azure-kusto-data";
    changelog = "https://github.com/Azure/azure-kusto-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

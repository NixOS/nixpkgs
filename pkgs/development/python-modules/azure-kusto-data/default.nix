{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  azure-core,
  azure-identity,
  ijson,
  msal,
  python-dateutil,
  requests,

  # optional-dependencies

  # tests
  # aio:
  aiohttp,
  asgiref,
  # pandas:
  pandas,

  # tests
  aioresponses,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-kusto-data";
  version = "6.0.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-kusto-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iggsVxLmDbP6+oSPaIiujPLsZAWwm5VLZSl+HYm0DIQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/azure-kusto-data";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.9,<0.9.0" uv_build
  '';

  build-system = [ uv-build ];

  pythonRelaxDeps = [
    "ijson"
  ];
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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "azure.kusto.data" ];

  disabledTests = [
    # AssertionError: Attributes of DataFrame.iloc[:, 1] (column name="rowguid") are different
    "test_sanity_data_frame"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/aio/test_async_token_providers.py"
    "tests/test_token_providers.py"
    "tests/test_e2e_data.py"

    # AssertionError: assert <class 'pandas.Timestamp'> is <class 'pandas.api.typing.NaTType'>
    "tests/test_helpers.py"
  ];

  meta = {
    description = "Kusto Data Client";
    homepage = "https://github.com/Azure/azure-kusto-python/tree/master/azure-kusto-data";
    changelog = "https://github.com/Azure/azure-kusto-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

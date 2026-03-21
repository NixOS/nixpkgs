{
  lib,
  aiohttp,
  azure-kusto-data,
  azure-storage-blob,
  azure-storage-queue,
  buildPythonPackage,
  fetchFromGitHub,
  pandas,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  responses,
  uv-build,
  tenacity,
}:

buildPythonPackage rec {
  pname = "azure-kusto-ingest";
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
      --replace-fail "uv_build>=0.8.9,<0.9.0" uv-build
  '';

  build-system = [ uv-build ];

  dependencies = [
    azure-kusto-data
    azure-storage-blob
    azure-storage-queue
    tenacity
  ];

  pythonRelaxDeps = [
    "azure-storage-blob"
    "azure-storage-queue"
  ];

  optional-dependencies = {
    pandas = [ pandas ];
  };

  nativeCheckInputs = [
    aiohttp
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    responses
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "azure.kusto.ingest" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_e2e_ingest.py"
  ];

  meta = {
    description = "Module for Kusto Ingest";
    homepage = "https://github.com/Azure/azure-kusto-python/tree/master/azure-kusto-ingest";
    changelog = "https://github.com/Azure/azure-kusto-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  braceexpand,
  cloudpickle,
  humanize,
  msgspec,
  overrides,
  packaging,
  pydantic,
  python-dateutil,
  pyyaml,
  requests,
  tenacity,
  urllib3,
  xxhash,

  # optional-dependencies
  # botocore:
  wrapt,
  # etl:
  aiofiles,
  fastapi,
  flask,
  gunicorn,
  httpx,
  uvicorn,
  # mcp:
  mcp,
  # pytorch:
  alive-progress,
  torch,
  torchdata,
  webdataset,
}:

buildPythonPackage (finalAttrs: {
  pname = "aistore";
  version = "1.26.0";
  pyproject = true;
  __structuredAttrs = true;

  # Tags on GitHub do not match
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-eTbWh6ItlELF57ilQ8wOJ5A1PmX8c0suV8ms2Zh73GM=";
  };

  pythonRelaxDeps = [ "xxhash" ];

  build-system = [
    hatchling
  ];

  dependencies = [
    braceexpand
    cloudpickle
    humanize
    msgspec
    overrides
    packaging
    pydantic
    python-dateutil
    pyyaml
    requests
    tenacity
    urllib3
    xxhash
  ];

  optional-dependencies = {
    botocore = [
      wrapt
    ];
    etl = [
      aiofiles
      fastapi
      flask
      gunicorn
      httpx
      uvicorn
    ];
    mcp = [
      mcp
    ];
    pytorch = [
      alive-progress
      torch
      torchdata
      webdataset
    ];
  };

  pythonImportsCheck = [ "aistore" ];

  # No tests in the Pypi archive
  doCheck = false;

  meta = {
    description = "Client-side APIs to access and utilize clusters, buckets, and objects on AIStore";
    homepage = "https://aistore.nvidia.com";
    downloadPage = "https://github.com/NVIDIA/aistore/tree/main/python/aistore/sdk";
    changelog = "https://github.com/NVIDIA/aistore/blob/main/python/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})

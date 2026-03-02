{
  lib,
  aiohttp,
  azure-core,
  azure-datalake-store,
  azure-identity,
  azure-storage-blob,
  buildPythonPackage,
  fetchFromGitHub,
  fsspec,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "adlfs";
  version = "2026.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "adlfs";
    tag = finalAttrs.version;
    hash = "sha256-wpj0MTpP5fBKTWA7sy4eRQo084pc+oNZgHVieC5NL2A=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    azure-core
    azure-datalake-store
    azure-identity
    azure-storage-blob
    fsspec
  ];

  pythonRelaxDeps = [ "azure-datalake-store" ];

  # Tests require a running Docker instance
  doCheck = false;

  pythonImportsCheck = [ "adlfs" ];

  meta = {
    description = "Filesystem interface to Azure-Datalake Gen1 and Gen2 Storage";
    homepage = "https://github.com/fsspec/adlfs";
    changelog = "https://github.com/fsspec/adlfs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})

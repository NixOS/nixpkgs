{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  aiohttp,
  decorator,
  fsspec,
  google-auth,
  google-auth-oauthlib,
  google-cloud-storage,
  google-cloud-storage-control,
  requests,

  # optional-dependencies
  fusepy,
  crcmod,
}:

buildPythonPackage (finalAttrs: {
  pname = "gcsfs";
  version = "2026.8.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "gcsfs";
    tag = finalAttrs.version;
    hash = "sha256-IAXUqYeQu+Z2Z2OumIpYmYOFomsN0Ojx8YpGKE+7i1U=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiohttp
    decorator
    fsspec
    google-auth
    google-auth-oauthlib
    google-cloud-storage
    google-cloud-storage-control
    requests
  ];

  optional-dependencies = {
    gcsfuse = [ fusepy ];
    crc = [ crcmod ];
  };

  # Tests require a running Docker instance
  doCheck = false;

  pythonImportsCheck = [ "gcsfs" ];

  meta = {
    description = "Convenient Filesystem interface over GCS";
    homepage = "https://github.com/fsspec/gcsfs";
    changelog = "https://github.com/fsspec/gcsfs/raw/${finalAttrs.src.tag}/docs/source/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nbren12 ];
  };
})

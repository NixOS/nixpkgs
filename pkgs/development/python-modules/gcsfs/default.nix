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
  version = "2026.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "gcsfs";
    tag = finalAttrs.version;
    hash = "sha256-Q+aqlFyNiGj0alOrnyjV9ILSSv6jRp+2DjDF/+f65po=";
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

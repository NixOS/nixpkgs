{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  google-auth,
  google-auth-oauthlib,
  google-cloud-storage,
  google-cloud-storage-control,
  requests,
  decorator,
  fsspec,
  fusepy,
  aiohttp,
  crcmod,
}:

buildPythonPackage rec {
  pname = "gcsfs";
  version = "2026.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "gcsfs";
    tag = version;
    hash = "sha256-WAHRaLsb6znzfuTOtulDhI0rQOOmmcgv9UEEMujPgkE=";
  };

  build-system = [
    setuptools
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
    changelog = "https://github.com/fsspec/gcsfs/raw/${src.tag}/docs/source/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nbren12 ];
  };
}

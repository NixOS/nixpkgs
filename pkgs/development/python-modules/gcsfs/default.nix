{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  google-auth,
  google-auth-oauthlib,
  google-cloud-storage,
  requests,
  decorator,
  fsspec,
  fusepy,
  aiohttp,
  crcmod,
  pytest-timeout,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "gcsfs";
  version = "2025.3.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "gcsfs";
    tag = version;
    hash = "sha256-aXBlj9ej3Ya7h4x/akl/iX6dDS/SgkkEsOQ2E9KmCDU=";
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
    requests
  ];

  optional-dependencies = {
    gcsfuse = [ fusepy ];
    crc = [ crcmod ];
  };

  nativeCheckInputs = [
    pytest-timeout
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Cannot connect to host storage.googleapis.com:443
    "test_credentials_from_raw_token"
  ];

  disabledTestPaths = [
    # Tests require a running Docker instance
    "gcsfs/tests/test_core.py"
    "gcsfs/tests/test_mapping.py"
    "gcsfs/tests/test_retry.py"
    "gcsfs/tests/derived/gcsfs_test.py"
    "gcsfs/tests/test_inventory_report_listing.py"
  ];

  pythonImportsCheck = [ "gcsfs" ];

  meta = {
    description = "Convenient Filesystem interface over GCS";
    homepage = "https://github.com/fsspec/gcsfs";
    changelog = "https://github.com/fsspec/gcsfs/raw/${version}/docs/source/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nbren12 ];
  };
}

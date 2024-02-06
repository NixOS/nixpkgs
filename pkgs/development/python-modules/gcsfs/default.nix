{ lib
, aiohttp
, buildPythonPackage
, crcmod
, decorator
, fetchFromGitHub
, fsspec
, google-auth
, google-auth-oauthlib
, google-cloud-storage
, pytest-asyncio
, pytest-timeout
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
, setuptools
, ujson
, vcrpy
}:

buildPythonPackage rec {
  pname = "gcsfs";
  version = "2024.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "gcsfs";
    rev = "refs/tags/${version}";
    hash = "sha256-rmXQVc4sfHbXQ8HC+15gEYPmLvZ82QYKzhhhdrt3LAM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    crcmod
    decorator
    fsspec
    google-auth
    google-auth-oauthlib
    google-cloud-storage
    requests
    ujson
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytest-vcr
    pytestCheckHook
    vcrpy
  ];

  disabledTestPaths = [
    # Tests require a running Docker instance
    "gcsfs/tests/derived/gcsfs_test.py"
    "gcsfs/tests/test_core.py"
    "gcsfs/tests/test_inventory_report_listing.py"
    "gcsfs/tests/test_mapping.py"
    "gcsfs/tests/test_retry.py"
  ];

  disabledTests = [
    # Test requires network access
    "test_credentials_from_raw_token"
  ];

  pytestFlagsArray = [
    "-x"
  ];

  pythonImportsCheck = [
    "gcsfs"
  ];

  meta = with lib; {
    description = "Convenient Filesystem interface over GCS";
    homepage = "https://github.com/fsspec/gcsfs";
    changelog = "https://github.com/fsspec/gcsfs/raw/${version}/docs/source/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nbren12 ];
  };
}

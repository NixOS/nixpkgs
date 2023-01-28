{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, google-auth
, google-auth-oauthlib
, google-cloud-storage
, requests
, decorator
, fsspec
, ujson
, aiohttp
, crcmod
, pytest-vcr
, vcrpy
}:

buildPythonPackage rec {
  pname = "gcsfs";
  version = "2022.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = pname;
    rev = version;
    hash = "sha256-+S4AziibYWos/hZ1v3883b1Vv3y4xjIDUrQ8c2XJ1MQ=";
  };

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
    pytest-vcr
    pytestCheckHook
    vcrpy
  ];

  disabledTestPaths = [
    # Tests require a running Docker instance
    "gcsfs/tests/test_core.py"
    "gcsfs/tests/test_mapping.py"
    "gcsfs/tests/test_retry.py"
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

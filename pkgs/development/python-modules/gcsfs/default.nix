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
, pytest-timeout
, pytest-vcr
, vcrpy
}:

buildPythonPackage rec {
  pname = "gcsfs";
  version = "2023.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FHS+g0SuYH9OPiE/+p2SHrsWfzBQ82GM6hTph8koh+o=";
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
    pytest-timeout
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

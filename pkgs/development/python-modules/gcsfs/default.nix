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
  version = "2021.10.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dask";
    repo = pname;
    rev = version;
    sha256 = "sha256-BME40kyxZHx9+XrMCqWYp8+q6tjeYwAw/zISMNpQxDU=";
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

  checkInputs = [
    pytest-vcr
    pytestCheckHook
    vcrpy
  ];

  disabledTests = [
    # Tests wants to communicate with the Link-local address
    "test_GoogleCredentials_None"
  ];

  pythonImportsCheck = [
    "gcsfs"
  ];

  meta = with lib; {
    description = "Convenient Filesystem interface over GCS";
    homepage = "https://github.com/dask/gcsfs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nbren12 ];
  };
}

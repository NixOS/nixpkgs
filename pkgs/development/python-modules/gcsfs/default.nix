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
    owner = "fsspec";
    repo = pname;
    rev = version;
    sha256 = "sha256-cpV+HKE39Yct1yu5xW9HZftx2Wy9ydFL2YLvPD3YM2M=";
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
    homepage = "https://github.com/fsspec/gcsfs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nbren12 ];
  };
}

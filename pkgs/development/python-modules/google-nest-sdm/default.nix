{ lib
, aiohttp
, asynctest
, buildPythonPackage
, coreutils
, fetchFromGitHub
, google-auth
, google-auth-oauthlib
, google-cloud-pubsub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "google-nest-sdm";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "python-google-nest-sdm";
    rev = version;
    sha256 = "sha256-8Y3ixkDl/AmXQMOY+29og5njMh9M2qjwWBGCsiqX5PU=";
  };

  propagatedBuildInputs = [
    aiohttp
    google-auth
    google-auth-oauthlib
    google-cloud-pubsub
    requests_oauthlib
  ];

  checkInputs = [
    asynctest
    coreutils
    pytest-aiohttp
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace tests/event_media_test.py \
      --replace "/bin/echo" "${coreutils}/bin/echo"
  '';

  pythonImportsCheck = [
    "google_nest_sdm"
  ];

  meta = with lib; {
    description = "Python module for Google Nest Device Access using the Smart Device Management API";
    homepage = "https://github.com/allenporter/python-google-nest-sdm";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

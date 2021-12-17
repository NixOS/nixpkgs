{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, google-auth
, google-auth-oauthlib
, google-cloud-pubsub
, pythonOlder
, requests_oauthlib
, pytest-aiohttp
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "google-nest-sdm";
  version = "0.4.8";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "python-google-nest-sdm";
    rev = version;
    sha256 = "sha256-HHjCML/55jthqZ5WjNNsldr+8nul8bd8N9aNAoe/iBw=";
  };

  propagatedBuildInputs = [
    aiohttp
    google-auth
    google-auth-oauthlib
    google-cloud-pubsub
    requests_oauthlib
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

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

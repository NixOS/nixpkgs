{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, websocket-client
, xmltodict
}:

buildPythonPackage rec {
  pname = "pyskyqremote";
  version = "0.3.25";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RogerSelwyn";
    repo = "skyq_remote";
    rev = "refs/tags/${version}";
    hash = "sha256-yDeGY5BFj0DKqqK+CzrIxqLa7G5C6Le+GIcFHwtJK9E=";
  };

  propagatedBuildInputs = [
    requests
    websocket-client
    xmltodict
  ];

  # Project has no tests, only a test script which looks like anusage example
  doCheck = false;

  pythonImportsCheck = [
    "pyskyqremote"
  ];

  meta = with lib; {
    description = "Python module for accessing SkyQ boxes";
    homepage = "https://github.com/RogerSelwyn/skyq_remote";
    changelog = "https://github.com/RogerSelwyn/skyq_remote/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

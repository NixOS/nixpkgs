{ lib
, aiohttp
, backoff
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools-scm
, yarl
}:

buildPythonPackage rec {
  pname = "geocachingapi";
  version = "0.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Sholofly";
    repo = "geocachingapi-python";
    rev = "refs/tags/${version}";
    sha256 = "sha256-C4nj4KFEwsY5V5f0Q1x+9sD8Ihz5m7b3jg2pOyB/pDg=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    aiohttp
    backoff
    yarl
  ];

  # Tests require a token and network access
  doCheck = false;

  pythonImportsCheck = [
    "geocachingapi"
  ];

  meta = with lib; {
    description = "Python API to control the Geocaching API";
    homepage = "https://github.com/Sholofly/geocachingapi-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

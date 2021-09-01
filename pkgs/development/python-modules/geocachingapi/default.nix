{ lib
, aiohttp
, backoff
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, yarl
}:

buildPythonPackage rec {
  pname = "geocachingapi";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Sholofly";
    repo = "geocachingapi-python";
    rev = version;
    sha256 = "1vdknsxd7rvw6g5lwxlxj97l9ic8cch8rdki3aczs6xzw5adxhcs";
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

  pythonImportsCheck = [ "geocachingapi" ];

  meta = with lib; {
    description = "Python API to control the Geocaching API";
    homepage = "https://github.com/Sholofly/geocachingapi-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

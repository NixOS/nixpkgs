{
  lib,
  aiohttp,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  reverse-geocode,
  setuptools-scm,
  yarl,
}:

buildPythonPackage rec {
  pname = "geocachingapi";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Sholofly";
    repo = "geocachingapi-python";
    rev = "refs/tags/${version}";
    hash = "sha256-zme1jqn3qtoo39zyj4dKxt9M7gypMqJu0bfgY1iYhjs=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    backoff
    reverse-geocode
    yarl
  ];

  # Tests require a token and network access
  doCheck = false;

  pythonImportsCheck = [ "geocachingapi" ];

  meta = with lib; {
    description = "Python API to control the Geocaching API";
    homepage = "https://github.com/Sholofly/geocachingapi-python";
    changelog = "https://github.com/Sholofly/geocachingapi-python/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

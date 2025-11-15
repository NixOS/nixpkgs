{
  lib,
  aiohttp,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  reverse-geocode,
  setuptools-scm,
  yarl,
}:

buildPythonPackage rec {
  pname = "geocachingapi";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sholofly";
    repo = "geocachingapi-python";
    tag = version;
    hash = "sha256-zme1jqn3qtoo39zyj4dKxt9M7gypMqJu0bfgY1iYhjs=";
  };

  patches = [
    # https://github.com/Sholofly/geocachingapi-python/pull/25
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio.timeout.patch";
      url = "https://github.com/Sholofly/geocachingapi-python/commit/2ba042bc2a6ebb4a494f71821502df4534eeb1a1.patch";
      hash = "sha256-AtjZJ9tnBeOv76fVIiqY45MeYTzcWvXCtbc6DevH8aM=";
    })
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    backoff
    reverse-geocode
    yarl
  ];

  pythonRelaxDeps = [ "reverse_geocode" ];

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

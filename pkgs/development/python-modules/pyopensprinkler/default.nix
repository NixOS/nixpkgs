{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  backoff,
}:

buildPythonPackage rec {
  pname = "pyopensprinkler";
  version = "0.7.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vinteo";
    repo = "py-opensprinkler";
    rev = version;
    hash = "sha256-OfC3YYP2GeoiJh+3Ti35dmjtjg4xpN7KXPy/5BA3pPs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    backoff
  ];

  # There are no unit tests upstream. The existing tests are unmaintained
  # integration tests that run against a docker container.
  # See <https://github.com/vinteo/py-opensprinkler/issues/4>.
  doCheck = false;

  pythonImportsCheck = [ "pyopensprinkler" ];

  meta = {
    changelog = "https://github.com/vinteo/py-opensprinkler/releases/tag/${version}";
    homepage = "https://github.com/vinteo/py-opensprinkler";
    maintainers = with lib.maintainers; [ jfly ];
    license = lib.licenses.mit;
    description = "Python module for OpenSprinker API";
  };
}

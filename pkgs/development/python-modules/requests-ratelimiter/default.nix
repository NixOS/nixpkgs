{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyrate-limiter,
  pytestCheckHook,
  requests-mock,
  requests,
  requests-cache,
}:

buildPythonPackage rec {
  pname = "requests-ratelimiter";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JWCook";
    repo = "requests-ratelimiter";
    tag = "v${version}";
    hash = "sha256-/fyZ+fjboAw97FPI6TgcjHRUAJbdNomvh7xJqTrTmuY=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pyrate-limiter
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-cache
    requests-mock
  ];

  pythonImportsCheck = [ "requests_ratelimiter" ];

  meta = {
    # https://github.com/JWCook/requests-ratelimiter/issues/78
    broken = lib.versionAtLeast pyrate-limiter.version "3";
    description = "Module for rate-limiting for requests";
    homepage = "https://github.com/JWCook/requests-ratelimiter";
    changelog = "https://github.com/JWCook/requests-ratelimiter/blob/${src.rev}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

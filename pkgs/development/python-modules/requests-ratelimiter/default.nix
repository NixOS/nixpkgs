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
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JWCook";
    repo = "requests-ratelimiter";
    tag = "v${version}";
    hash = "sha256-jmHXD3UJwzZSLXS7NXvCM/+lOFreSqb1QIl/jvO8lWc=";
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
    broken = lib.versionOlder pyrate-limiter.version "4";
    description = "Module for rate-limiting for requests";
    homepage = "https://github.com/JWCook/requests-ratelimiter";
    changelog = "https://github.com/JWCook/requests-ratelimiter/blob/${src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

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

buildPythonPackage (finalAttrs: {
  pname = "requests-ratelimiter";
  version = "0.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JWCook";
    repo = "requests-ratelimiter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Uw6JPArOzKD7va6mthumCDW/G0Yn/C1d+1VflrJ/JY=";
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
    description = "Module for rate-limiting for requests";
    homepage = "https://github.com/JWCook/requests-ratelimiter";
    changelog = "https://github.com/JWCook/requests-ratelimiter/blob/${finalAttrs.src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

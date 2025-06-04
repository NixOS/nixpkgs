{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyrate-limiter,
  pytestCheckHook,
  pythonOlder,
  requests-mock,
  requests,
  requests-cache,
}:

buildPythonPackage rec {
  pname = "requests-ratelimiter";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JWCook";
    repo = "requests-ratelimiter";
    tag = "v${version}";
    hash = "sha256-DS4BzS8AD4axniyV6jVYXWZ6cQLvMPp8tdGoBhYu51o=";
  };

  build-system = [ poetry-core ];

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

  meta = with lib; {
    # https://github.com/JWCook/requests-ratelimiter/issues/78
    broken = lib.versionAtLeast pyrate-limiter.version "3";
    description = "Module for rate-limiting for requests";
    homepage = "https://github.com/JWCook/requests-ratelimiter";
    changelog = "https://github.com/JWCook/requests-ratelimiter/blob/${src.rev}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}

{
  buildPythonPackage,
  dirty-equals,
  fetchFromGitHub,
  hatchling,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  responses,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-backoff";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-backoff";
    repo = "backoff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qrPlszLO5eSYjZi638yH2hUV5zASgzMmiGKsEKGlLEA=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "backoff" ];

  nativeCheckInputs = [
    dirty-equals
    pytest-asyncio
    pytestCheckHook
    requests
    responses
  ];

  meta = {
    changelog = "https://github.com/python-backoff/backoff/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Python library providing function decorators for configurable backoff and retry";
    homepage = "https://github.com/python-backoff/backoff";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})

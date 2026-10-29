{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  requests,
  setuptools,
  websocket-client,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-dactyl";
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iamkubi";
    repo = "pydactyl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WgsykxwcpUasbYJdhM2s/+a7SaORzA7mW+9AhORxcbA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
    websocket-client
  ];

  pythonImportsCheck = [ "pydactyl" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # upstream's tests are not fully maintained
    "test_paginated_response_multipage_iterator"
  ];

  meta = {
    changelog = "https://github.com/iamkubi/pydactyl/releases/tag/${finalAttrs.src.tag}";
    description = "Python wrapper for the Pterodactyl Panel API";
    homepage = "https://github.com/iamkubi/pydactyl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})

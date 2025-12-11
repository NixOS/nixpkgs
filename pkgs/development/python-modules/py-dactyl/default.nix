{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-dactyl";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iamkubi";
    repo = "pydactyl";
    tag = "v${version}";
    hash = "sha256-1bvdJ9ATF0cRy7WE8H2IV2WIMbiSnRnelGpWIN7VBRQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
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
    changelog = "https://github.com/iamkubi/pydactyl/releases/tag/${src.tag}";
    description = "Python wrapper for the Pterodactyl Panel API";
    homepage = "https://github.com/iamkubi/pydactyl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

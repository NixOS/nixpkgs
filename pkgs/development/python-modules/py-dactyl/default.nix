{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-dactyl";
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iamkubi";
    repo = "pydactyl";
    tag = "v${version}";
    hash = "sha256-yw5S4I4mtb9URnZ1So1nlZi4v7y0Nz4msx+8SwSi8N4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [ "pydactyl" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # upstream's tests are not fully maintained
    "test_get_file_contents"
    "test_paginated_response_multipage_iterator"
    "test_pterodactyl_client_debug_param"
  ];

  meta = {
    changelog = "https://github.com/iamkubi/pydactyl/releases/tag/${src.tag}";
    description = "Python wrapper for the Pterodactyl Panel API";
    homepage = "https://github.com/iamkubi/pydactyl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

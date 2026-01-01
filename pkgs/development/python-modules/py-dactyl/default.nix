{
<<<<<<< HEAD
  aiohttp,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-dactyl";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "2.0.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iamkubi";
    repo = "pydactyl";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-1bvdJ9ATF0cRy7WE8H2IV2WIMbiSnRnelGpWIN7VBRQ=";
=======
    hash = "sha256-yw5S4I4mtb9URnZ1So1nlZi4v7y0Nz4msx+8SwSi8N4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
<<<<<<< HEAD
    aiohttp
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    requests
  ];

  pythonImportsCheck = [ "pydactyl" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # upstream's tests are not fully maintained
<<<<<<< HEAD
    "test_paginated_response_multipage_iterator"
=======
    "test_get_file_contents"
    "test_paginated_response_multipage_iterator"
    "test_pterodactyl_client_debug_param"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  meta = {
    changelog = "https://github.com/iamkubi/pydactyl/releases/tag/${src.tag}";
    description = "Python wrapper for the Pterodactyl Panel API";
    homepage = "https://github.com/iamkubi/pydactyl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

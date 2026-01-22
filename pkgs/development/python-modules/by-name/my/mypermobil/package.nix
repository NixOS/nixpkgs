{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  setuptools,
  aiocache,
  aiohttp,
  aiounittest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mypermobil";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Permobil-Software";
    repo = "mypermobil";
    tag = "v${version}";
    hash = "sha256-linnaRyA45EzqeSeNmvIE5gXkHA2F504U1++QBeRa90=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiocache
    aiohttp
  ];

  pythonImportsCheck = [ "mypermobil" ];

  nativeCheckInputs = [
    aiounittest
    pytestCheckHook
  ];

  disabledTests = [
    # requires networking
    "test_region"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # AssertionError: MyPermobilAPIException not raised
    "test_request_item_404"
  ];

  meta = {
    changelog = "https://github.com/Permobil-Software/mypermobil/releases/tag/v${version}";
    description = "Python wrapper for the MyPermobil API";
    homepage = "https://github.com/Permobil-Software/mypermobil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

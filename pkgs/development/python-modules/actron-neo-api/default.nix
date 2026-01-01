{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "actron-neo-api";
<<<<<<< HEAD
  version = "0.1.87";
=======
  version = "0.1.84";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kclif9";
    repo = "actronneoapi";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-8Y1vl+KjjAnobb9wORZCcXTLStuGOth3dlX0Goq+pxE=";
=======
    hash = "sha256-ihIg264ZX0tCfRwVLkiq62ke2G125ObcrVabPCDrc4c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    pydantic
  ];

  pythonImportsCheck = [ "actron_neo_api" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # test hangs
    "test_poll_for_token_pending"
    # AttributeError: property 'authorization_header' of 'ActronAirOAuth2DeviceCodeAuth' object has no setter
    "test_lazy_token_refres"
    # ActronAirAuthError: Refresh token is required to refresh the access token
    "test_get_user_info"
  ];

  meta = {
    changelog = "https://github.com/kclif9/actronneoapi/releases/tag/${src.tag}";
    description = "Communicate with Actron Air systems via the Actron Neo API";
    homepage = "https://github.com/kclif9/actronneoapi";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}

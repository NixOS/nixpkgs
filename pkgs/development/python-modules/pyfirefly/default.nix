{
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  orjson,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "pyfirefly";
<<<<<<< HEAD
  version = "0.1.9";
=======
  version = "0.1.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "pyfirefly";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VPtXk4sObN5mvZTtmXW+myQ4+Slb285zHMotRkLyhJM=";
=======
    hash = "sha256-b4np7JlDCbrrMo6TGE5yL6Xg41ocGoJQY8BMH/hZ9Ls=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  pythonImportsCheck = [ "pyfirefly" ];

  nativeCheckInputs = [
    aresponses
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/erwindouna/pyfirefly/releases/tag/${src.tag}";
    description = "Asynchronous Python client for the Firefly III API";
    homepage = "https://github.com/erwindouna/pyfirefly";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}

{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pycync";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "Kinachi249";
    repo = "pycync";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-mYHUkenP0FMnwKOdZe4XjC/VnP3JJGPtuVdYR9UcouM=";
=======
    hash = "sha256-UjodZbgicTiJV4T5yqWy5J4oAeZGbggVfaPMoDmL74M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "pycync" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    cd tests
  '';

  meta = {
    changelog = "https://github.com/Kinachi249/pycync/releases/tag/${src.tag}";
    description = "Python API library for Cync smart devices";
    homepage = "https://github.com/Kinachi249/pycync";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}

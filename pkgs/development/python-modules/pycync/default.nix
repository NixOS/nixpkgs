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
  version = "0.4.3";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "Kinachi249";
    repo = "pycync";
    tag = "v${version}";
    hash = "sha256-UjodZbgicTiJV4T5yqWy5J4oAeZGbggVfaPMoDmL74M=";
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

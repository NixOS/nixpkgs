{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pytestCheckHook,
  setuptools,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "aqualogic";
  version = "3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "swilson";
    repo = "aqualogic";
    tag = finalAttrs.version;
    hash = "sha256-M/08Wu9ANFQlev2nOzlG9R40Nuw5hy5T288dWaqV98g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pyserial
    websockets
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # With 3.4 the event loop is not terminated after the first test
  # https://github.com/swilson/aqualogic/issues/9
  doCheck = false;

  pythonImportsCheck = [ "aqualogic" ];

  meta = {
    description = "Python library to interface with Hayward/Goldline AquaLogic/ProLogic pool controllers";
    homepage = "https://github.com/swilson/aqualogic";
    changelog = "https://github.com/swilson/aqualogic/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})

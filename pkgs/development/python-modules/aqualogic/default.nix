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
  version = "3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "swilson";
    repo = "aqualogic";
    tag = finalAttrs.version;
    hash = "sha256-2dydjbbWYqtj7SKRJ3fpugFLOYXEDRDL9wyMV1ClHws=";
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

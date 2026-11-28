{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiolibresync";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "drsound";
    repo = "aiolibresync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N69rpWbiy89Icmusbt3lX2svQnJZRHk0M2KEPY8HMX4=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiolibresync" ];

  meta = {
    description = "Async client for Libre Wireless LibreSync audio hubs, such as the Platin Stereo Hub";
    homepage = "https://github.com/drsound/aiolibresync";
    changelog = "https://github.com/drsound/aiolibresync/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})

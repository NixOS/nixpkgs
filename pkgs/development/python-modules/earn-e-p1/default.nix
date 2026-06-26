{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "earn-e-p1";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Miggets7";
    repo = "earn-e-p1";
    tag = finalAttrs.version;
    hash = "sha256-a76+slVhZj6AQIDCcaEym3G6DjIsQQLfi13wIsYGkjA=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "earn_e_p1" ];

  meta = {
    description = "Async Python library for communicating with EARN-E P1 energy meters via UDP";
    homepage = "https://github.com/Miggets7/earn-e-p1";
    changelog = "https://github.com/Miggets7/earn-e-p1/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})

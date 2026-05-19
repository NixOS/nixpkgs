{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  serialx,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "denon-rs232";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "denon-rs232";
    tag = finalAttrs.version;
    hash = "sha256-SkfxUen1F5cakQao68uYz5uxAkzJfZtVtuIoFGH6mOU=";
  };

  build-system = [ uv-build ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"' \
      --replace-fail '"uv_build>=0.8.4,<0.9.0"' '"uv_build>=0.8.4"'
  '';

  dependencies = [ serialx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "denon_rs232" ];

  meta = {
    description = "Async library to control Denon receivers over RS232";
    homepage = "https://github.com/home-assistant-libs/denon-rs232";
    changelog = "https://github.com/home-assistant-libs/denon-rs232/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})

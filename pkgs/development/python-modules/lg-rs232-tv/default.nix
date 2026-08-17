{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  serialx,
  aiowebostv,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lg-rs232-tv";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "lg-rs232-tv";
    tag = finalAttrs.version;
    hash = "sha256-gMjRyZ/gUMAsS0v465ISD38YAlrOB8N/5VAFZkXtyAE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.4,<0.9.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ serialx ];

  optional-dependencies = {
    esphome = serialx.optional-dependencies.esphome;
    remote = [ aiowebostv ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "lg_rs232_tv" ];

  meta = {
    description = "Async library to control LG TVs over RS232";
    homepage = "https://github.com/home-assistant-libs/lg-rs232-tv";
    changelog = "https://github.com/home-assistant-libs/lg-rs232-tv/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})

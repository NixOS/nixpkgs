{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  serialx,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "marantz-rs232";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "marantz-rs232";
    tag = finalAttrs.version;
    hash = "sha256-t/3TQNvwwqwWkcKC3lEmM9iJK6vjJ5WgqvP1fbC82vI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.4,<0.9.0" "uv_build>=0.8.4"
  '';

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ uv-build ];

  dependencies = [ serialx ] ++ serialx.optional-dependencies.esphome;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "marantz_rs232" ];

  meta = {
    description = "Async library to control Marantz receivers over RS232";
    homepage = "https://github.com/home-assistant-libs/marantz-rs232";
    changelog = "https://github.com/home-assistant-libs/marantz-rs232/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
    mainProgram = "marantz-rs232";
  };
})

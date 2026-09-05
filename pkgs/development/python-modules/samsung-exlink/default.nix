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
  pname = "samsung-exlink";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "samsung-exlink";
    tag = finalAttrs.version;
    hash = "sha256-JnuHinva05/nG93qNYojIe6c/UkjrN2y16Cwi1BnQQM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.4,<0.9.0" "uv_build"
  '';

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ uv-build ];

  dependencies = [ serialx ] ++ serialx.optional-dependencies.esphome;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "samsung_exlink" ];

  meta = {
    description = "Async library to control Samsung consumer TVs over RS232";
    homepage = "https://github.com/home-assistant-libs/samsung-exlink";
    changelog = "https://github.com/home-assistant-libs/samsung-exlink/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})

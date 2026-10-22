{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,

  # build-system
  setuptools,

  # dependencies
  anyascii,
  mashumaro,
  orjson,

  # tests
  pytestCheckHook,
  pytest-cov-stub,

  # reverse dependencies
  music-assistant,
  music-assistant-client,
}:

buildPythonPackage (finalAttrs: {
  pname = "music-assistant-models";
  # Must be compatible with music-assistant-client package
  # nixpkgs-update: no auto update
  version = "1.1.189";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "models";
    tag = finalAttrs.version;
    hash = "sha256-oB2ifUUysaJU/nUyTip0C06QujoFSjgowctadIHxDiQ=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [
    anyascii
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "music_assistant_models"
  ];

  passthru.tests = {
    inherit music-assistant music-assistant-client;
  };

  meta = {
    description = "Models used by Music Assistant (shared by client and server)";
    homepage = "https://github.com/music-assistant/models";
    changelog = "https://github.com/music-assistant/models/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})

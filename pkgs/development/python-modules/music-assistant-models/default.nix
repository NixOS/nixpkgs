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
  unidecode,

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
  version = "1.1.152";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "models";
    tag = finalAttrs.version;
    hash = "sha256-tdjqg6N/g8fRtcpj7RLQ2QeX0f3zQlMndIfNTgtlCf4=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  dependencies = [
    mashumaro
    orjson
    # TODO: remove when home-assistant updated to at least this version, too
    (if lib.versionAtLeast finalAttrs.version "1.1.189" then anyascii else unidecode)
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

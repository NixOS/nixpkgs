{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  mashumaro,
  orjson,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "music-assistant-models";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "models";
    tag = version;
    hash = "sha256-keig18o32X53q/QcoaPO0o9AT4XTEZ+dQ3L6u6BVkLU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
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

  meta = {
    description = "Models used by Music Assistant (shared by client and server";
    homepage = "https://github.com/music-assistant/models";
    changelog = "https://github.com/music-assistant/models/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
